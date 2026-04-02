(*******************************************************************************
CBM: general monotioring task  (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company. 
Copyright, INNIO Company, 2023

- GEN2diag checks the lambda movement AND shut down the engine in CASE OF a friciton event
- FricIMEP checks the friction power AND shut down the engine in CASE OF an increase

Customized modifications: -
------------------------
 
History:
-------

V4.05.0 xx-xx-2018 	Waldhart, 	created
V4.06.0 24-07-2018 	Waldhart, 	GEN2diag V0.3.9 implemented
		30-07-2018	502423184	replaced Para.bGEN2_preM_Act
V4.07.0 20-09-2018 	Waldhart, 	add containment for IMEP based friction monitoring rca
		09-10-2018 	Waldhart, 	IMEP based friction monitoring V0.06.0 implemented
		30-10-2018 	502423184, 	xGEN2diag von V4.6 übernommen
V4.09.0	23-01-2020	Schmidt,	GEN2diag: added interface for deactivation when LX2 is switched off
V4.10.0	22-07-2020	Schmidt,	IMEP based friction monitoring V0.07.1: exclude cylinders from monitoring if pressure sensor malfunction/error
V4.12.0	10-05-2022	Schmidt,	GEN2diag: increased delay for first activation to avoid FP detections while in GEN2 lambda minimum (issue #806)
V4.12.0	03-10-2022	Kafka,		desensitize voltage plausibility for IMEPbFricMon
		25-01-2023	Perktold, 	added variabel names to remove warnings after T9 task deactivation
V4.13.0	19-10-2023	Schmidt,	GEN2diag: for PBC deactivate monitoring during misfire (issue #1076)
		
Instructions FOR use:
--------------------

Outstandings:
------------

*******************************************************************************)	
PROGRAM _INIT
		
	(*** GEN2 Friction monitoring ***)
	xGEN2diag.ssMethodType 		:= 3;
			
	(* transient detection *)
	xGEN2diag.Para.TrshPsetDev  		:= 0.02;	(* threshold value for power set point deviation [p.u.] *)
	xGEN2diag.Para.TrshPsetStat 		:= 0.02;	(* threshold value for steady state detection [p.u.] *)	

	xGEN2diag.Para.TconstPsetStat 		:= 10.0;	(* timeconstant for steady state detection *)
	xGEN2diag.Para.TrshLoad 			:= 0.3;		(* threshold value for load level (related to the set power point) [p.u.] *)
		
	xGEN2diag.Para.TConstLP				:= 5.0; 	(* time constant [s] for the lambda lowpass filter *)
	xGEN2diag.Para.TConstHP             := 10.0; 	(* time constant [s] for the lambda highpass filter (situated after the lowpass) *)
	
	// TODO: type 4 0.014; type 3 0.01
	xGEN2diag.Para.ITPmeanScaling 		:= 0.014;	(* scaling for the mean ITP to estimate a lambda change *)
	
	xGEN2diag.Para.FaultThrshLambda     := 0.007; 	(* threshold value for lambda fault detection *)
	xGEN2diag.Para.TPulseLambdaFault    := 10.0; 	(* minimum time [s] a lambda fault pulse is provided for further detection (exh. temp.) *)
	xGEN2diag.Para.DeltaTexhAllowed     := 3.0; 	(* max. allowed rise in avg. exhaust temp. used for fault detection *)
	
	xGEN2diag.Para.TexhPlausibleMin 	:= 10;		(*min. exhaust temperature which is considered plausible (to exclude faulty sensors)*)	
	xGEN2diag.Para.TexhPlausibleMax 	:= 850;		(*max. exhaust temperature which is considered plausible (to exclude faulty sensors)*)

	xGEN2diag.Para.WGM_FaultThrsh       := 0.1;     (*wastegate monitoring fault threshold*)
	xGEN2diag.Para.WGM_Tconst           := 1.0;     (*wastegate monitoring time constant*)
	
	xGEN2diag.Para.LEANOXErrorThrsh     := 0.01;   	(* threshold for leanox error (diagnosis gets active if the error is smaller than this threshold) *) 
	xGEN2diag.Para.LEANOXErrorTconst	:= 1.0;		(*time constant [s] FOR filtering p2s in LEANOX error calculation'*)

	xGEN2diag.Para.Vltg_FaultThrsh      := 0.02;    (*voltage monitoring fault threshold*)
	xGEN2diag.Para.Vltg_Tconst          := 1;       (*voltage monitoring time constant*)
    
	xGEN2diag.Para.TexhSettledThrsh		:= 0.8;		(* threshold for exhaust temperature settled detection *)
	xGEN2diag.Para.TexhSettledTConstLP	:= 5;		(* time constant [s] for the Texh lowpass filter -> settled detection *)
	xGEN2diag.Para.TexhSettledTConstHP	:= 5;		(* time constant [s] for the Texh highpass filter (situated after the lowpass) -> settled detection *)
	xGEN2diag.Para.TexhSettledMaxTD		:= 15;		(* max. time [s] after a power ramp after which the exhaust temperature is considered settled (even if the filter does not suggest this! *)

	xGEN2diag.Para.bGasMixingEnDet		:= TRUE;	(* enable gas mixing threshold detection *)
	xGEN2diag.Para.GasMixingThrsh		:= 0.6;		(* threshold for gas mixing transient detection *)
	xGEN2diag.Para.GasMixingTconstLP	:= 5;		(* time constant [s] for gas mixing transient detection lowpass *)
	xGEN2diag.Para.GasMixingTconstHP	:= 5;		(* time constant [s] for gas mixing transient detection highpass *)

	(****************************************************************************************************************************)

	FricIMEP_P20.ssMethodType := 3;

	FricIMEP_P20.Para.PFComp_CC.Sig[0] := 1.0; 		FricIMEP_P20.Para.PFComp_CC.Comp[0] := 1.0;
	FricIMEP_P20.Para.PFComp_CC.Sig[1] := 0.9; 		FricIMEP_P20.Para.PFComp_CC.Comp[1] := 1.0;
	FricIMEP_P20.Para.PFComp_CC.Sig[2] := 0.8; 		FricIMEP_P20.Para.PFComp_CC.Comp[2] := 1.0;

	FricIMEP_P20.Para.PFComp_G_CC.Sig[0] := 0.25; 		FricIMEP_P20.Para.PFComp_G_CC.Comp[0] := 1.0;
	FricIMEP_P20.Para.PFComp_G_CC.Sig[1] := 0.63; 		FricIMEP_P20.Para.PFComp_G_CC.Comp[1] := 1.0;
	FricIMEP_P20.Para.PFComp_G_CC.Sig[2] := 1.0; 		FricIMEP_P20.Para.PFComp_G_CC.Comp[2] := 1.0;

	FricIMEP_P20.Para.WGComp_CC.WG_Pos[0] := 0.0; 		FricIMEP_P20.Para.WGComp_CC.Comp[0] := 1.0;
	FricIMEP_P20.Para.WGComp_CC.WG_Pos[1] := 0.5; 		FricIMEP_P20.Para.WGComp_CC.Comp[1] := 0.85;
	FricIMEP_P20.Para.WGComp_CC.WG_Pos[2] := 1.0; 		FricIMEP_P20.Para.WGComp_CC.Comp[2] := 0.7;

	FricIMEP_P20.Para.TEOComp_CC.TEO[0] := 40.0; 		FricIMEP_P20.Para.TEOComp_CC.Comp[0] := 1.3;
	FricIMEP_P20.Para.TEOComp_CC.TEO[1] := 80.0; 		FricIMEP_P20.Para.TEOComp_CC.Comp[1] := 1.0;
	FricIMEP_P20.Para.TEOComp_CC.TEO[2] := 120.0; 		FricIMEP_P20.Para.TEOComp_CC.Comp[2] := 1.0;

	FricIMEP_P20.Para.WGM_FaultThrsh	:= 0.02;	(* wastegate monitoring fault threshold*)
	FricIMEP_P20.Para.WGM_Tconst        := 1.0;     (* wastegate monitoring time constant*)
	FricIMEP_P20.Para.WGM_y0            := 0.0;     (* wastegate monitoring initial condition*)
	FricIMEP_P20.Para.WGM_TDly          := 5.0;     (* wastegate monitoring time delay*)

	FricIMEP_P20.Para.Vltg_FaultThrsh   := 200.0;	(* voltage monitoring fault threshold*)
	FricIMEP_P20.Para.Vltg_Tconst       :=   1.0;   (* voltage monitoring time constant*)
	FricIMEP_P20.Para.Vltg_y0           :=   0.0;   (* voltage monitoring initial condition*)
	FricIMEP_P20.Para.Vltg_TDly         :=   5.0;   (* voltage monitoring time delay [sec]*)
	
	FricIMEP_P20.Para.rTconst_Power_Filt := 4;		(* Time constant FOR Power filter *)
	FricIMEP_P20.Para.rTconst_fricflt_fastfilt := 4;(* Time constant OF friction power filter  - fast filtering *) 
	FricIMEP_P20.Para.rTconst_fricflt_slowfilt := 8;(* Time constant OF friction power filter  - slow filtering *) 
	FricIMEP_P20.Para.rIC_Power_filt := 0;

	FricIMEP_P20.Para.Abs_Thrsh 		:= 1132;	(* Threshold set TO compare the absolute value OF friction power FOR fault detection *)
	FricIMEP_P20.Para.Diff_Thrsh 		:= 36;		(* Threshold set TO compare the friction power difference value OF fast AND slow filter FOR fault detection *)

	FricIMEP_P20.Para.ExtDist_TDly      := 15.0;    (* time delay after a external disturbtion*)
	FricIMEP_P20.Para.rPower_Thrsh 		:= -500.0;	(* Power threshold TO switch on fault detection algorithm *)
	FricIMEP_P20.Para.Speedrange 		:= 5;		(* speed range [rpm] *)
	FricIMEP_P20.Para.rNEngNom 			:= 1000; 	(* nominal engine speed [rpm] *)
	FricIMEP_P20.Para.LoadStep_TDly 	:= 10;		(* time delay after a load step [sec] *)

	FricIMEP_P20.Para.rInertia 			:= 5460; 	(* inertia of engine plus generator [kgm2] *)
	FricIMEP_P20.Para.rEngine_Vd 		:= 0.0264;	(* Engine displacement volume *)

	FricIMEP_P20.Para.rD_P_kin 			:= 1; 		(* Derivative gain *)
	FricIMEP_P20.Para.rN_P_kin 			:= 5; 		(* Derivative filter *)
	FricIMEP_P20.Para.rD0_init 			:= 105; 	(*  *)
	FricIMEP_P20.Para.IMEPVali_Fac 		:= 8.0;		(* factor for the imep validation layer *)

	FricIMEP_P20.Para.rP_Nom			:= 9500;

(****************************************************************************************************************************)

(** just to remove compiler warnings after diabeling of type 9 tasks *)

	ACE2MM;
	FAM_ACN;
	FAM_pu_idx;
	FAM_status;
	FAM_value;
	FDT_Diag_1;
	FDT_Diag_10;
	FDT_Diag_11;
	FDT_Diag_12;
	FDT_Diag_13;
	FDT_Diag_14;
	FDT_Diag_15;
	FDT_Diag_16;
	FDT_Diag_17;
	FDT_Diag_18;
	FDT_Diag_19;
	FDT_Diag_2;
	FDT_Diag_20;
	FDT_Diag_21;
	FDT_Diag_22;
	FDT_Diag_23;
	FDT_Diag_24;
	FDT_Diag_25;
	FDT_Diag_26;
	FDT_Diag_27;
	FDT_Diag_28;
	FDT_Diag_29;
	FDT_Diag_3;
	FDT_Diag_30;
	FDT_Diag_31;
	FDT_Diag_32;
	FDT_Diag_33;
	FDT_Diag_34;
	FDT_Diag_35;
	FDT_Diag_36;
	FDT_Diag_37;
	FDT_Diag_38;
	FDT_Diag_39;
	FDT_Diag_4;
	FDT_Diag_40;
	FDT_Diag_41;
	FDT_Diag_42;
	FDT_Diag_43;
	FDT_Diag_44;
	FDT_Diag_45;
	FDT_Diag_46;
	FDT_Diag_47;
	FDT_Diag_48;
	FDT_Diag_49;
	FDT_Diag_5;
	FDT_Diag_50;
	FDT_Diag_51;
	FDT_Diag_52;
	FDT_Diag_53;
	FDT_Diag_54;
	FDT_Diag_55;
	FDT_Diag_56;
	FDT_Diag_57;
	FDT_Diag_58;
	FDT_Diag_59;
	FDT_Diag_6;
	FDT_Diag_60;
	FDT_Diag_7;
	FDT_Diag_8;
	FDT_Diag_9;
	Info_FAM;
	Info_FDT;
	MM2ACE;
	Version_FAM;
	Version_FDT;
	bFAM_CmdOn;
	bFDT_CmdOn;
	bGCB_ON_data;
	eta_gen;
	eta_mot;
	eta_vol;
	iCnt_OpHours;
	iOpHours_Min;
	rCosPhi_Max_data;
	rCosPhi_Min_data;
	rFrequency_Max_data;
	rFrequency_Min_data;
	rI_L1_Max_data;
	rI_L1_Min_data;
	rI_L2_Max_data;
	rI_L2_Min_data;
	rI_L3_Max_data;
	rI_L3_Min_data;
	rIgn_Timing_data;
	rLambda_Set_Max_data;
	rLambda_Set_Min_data;
	rMFBvar_data;
	rN_Eng_Max_data;
	rN_Eng_Min_data;
	rN_TCHP_A_Max_data;
	rN_TCHP_A_Min_data;
	rN_TCHP_B_Max_data;
	rN_TCHP_B_Min_data;
	rN_TCLP_A_Max_data;
	rN_TCLP_A_Min_data;
	rN_TCLP_B_Max_data;
	rN_TCLP_B_Min_data;
	rPI_Duration_data;
	rPI_Map_Offs_data;
	rPI_PID_Offs_data;
	rP_Act_Max_data;
	rP_Act_Min_data;
	rP_Set_Max_data;
	rP_Set_Min_data;
	rPos_CBV_Act_A1_Max_data;
	rPos_CBV_Act_A1_Min_data;
	rPos_CBV_Act_B1_Max_data;
	rPos_CBV_Act_B1_Min_data;
	rPos_CBV_Set_Max_data;
	rPos_CBV_Set_Min_data;
	rPr_49afTDC_data;
	rPr_49bfTDC_data;
	rPr_Crank_Case_Max_data;
	rPr_Crank_Case_Min_data;
	rPr_GR_Act_Max_data;
	rPr_GR_Act_Min_data;
	rPr_GR_Set_Max_data;
	rPr_GR_Set_Min_data;
	rPr_IMEP_data;
	rPr_Knock_data;
	rPr_Leanox_Set_Max_data;
	rPr_Leanox_Set_Min_data;
	rPr_P2s_A_Max_data;
	rPr_P2s_A_Min_data;
	rPr_P2s_B_Max_data;
	rPr_P2s_B_Min_data;
	rPr_PC_Act_Max_data;
	rPr_PC_Act_Min_data;
	rPr_PC_Set_Max_data;
	rPr_PC_Set_Min_data;
	rPr_Peak_data;
	rQ_Act_Max_data;
	rQ_Act_Min_data;
	rT_CBearing_data;
	rT_EG_Cyl_data;
	rT_MBearing_data;
	rT_T2s_data;
	rU_Ign_data;
	rU_L1L2_Max_data;
	rU_L1L2_Min_data;
	rU_L2L3_Max_data;
	rU_L2L3_Min_data;
	rU_L3L1_Max_data;
	rU_L3L1_Min_data;
	shiftVec;
	ulGlowIgn_data;
	ulLimpHome_data;
	ulMisfire_II_data;
	ulMisfire_I_data;
	ulPBCCompLineCheck_data;
	ulPBCMemBurst_data;
	ulPBCNegPresCheck_data;
	ulPBCNegVoltCheck_data;
	ulPBCPresSlopeCheck_data;
	ulPBCSensError_data;
	ulPBCSlowDriftCheck_data;
	ulSkipFire_data;


END_PROGRAM

PROGRAM _CYCLIC


	IF xEngType.Type6 THEN
		xGEN2diag.Para.TConstLP				:= 10.0; 	(* time constant [s] for the lambda lowpass filter *)
		xGEN2diag.Para.ITPmeanScaling 		:= 0.0228;	(* scaling for the mean ITP to estimate a lambda change *)
	ELSIF xEngType.Type4 THEN
		xGEN2diag.Para.TConstLP				:= 5.0; 	(* time constant [s] for the lambda lowpass filter *)
		xGEN2diag.Para.ITPmeanScaling 		:= 0.014;	(* scaling for the mean ITP to estimate a lambda change *)
	ELSIF xEngType.Type3 OR xEngType.Type2 THEN
		xGEN2diag.Para.TConstLP				:= 5.0; 	(* time constant [s] for the lambda lowpass filter *)
		xGEN2diag.Para.ITPmeanScaling 		:= 0.01;	(* scaling for the mean ITP to estimate a lambda change *)
	ELSE (*J920*)	
	
	END_IF;
	
	xGEN2diag.Para.NCyl       			:= xEngType.NumberOfCylinder; 		(* number of cylinders *)
	xGEN2diag.Para.ThrshScale			:= Para.rScal_Lam_Mon_Limit;		(* GEN2 Scaling of Lambda monitoring Trip Threshold *)	
	
	IF bGEN2diag_afterGCBon THEN	
		xGEN2diag.Para.MonitoringDelay	:= 180.0;							(* GEN2 Lambda monitoring activation delay after engine start, increased delay to avoid false-positive detection by changing gas quality *)
	ELSE
		xGEN2diag.Para.MonitoringDelay	:= Para.rScal_Lam_Mon_Delay;		(* GEN2 Lambda monitoring activation delay *)
	END_IF;
	xGEN2diag.In.bFileOnlyInTrans		:= Para.bLam_Mon_ECBTCB_Ramps;		(* write files only (don't initiate a trip) during power ramps (only if detection is allowed during ramps) *)

	IF NOT xOpMode.NetP THEN
		bGEN2diag_afterGCBon := TRUE;
	ELSIF bLamMon_DiagActive THEN
		bGEN2diag_afterGCBon := FALSE;
	END_IF;
	
	xGEN2diag.In.bFileOnlyInTrans		:= Para.bLam_Mon_ECBTCB_Ramps;		(* write files only (don't initiate a trip) during power ramps (only if detection is allowed during ramps) *)

	(*** GEN2 Friction monitoring ***)
	xGEN2diag.In.bAllowDetInTrans 	:= Para.bLam_Mon_Act_Ramps; (*allow detection in transients*)

	xGEN2diag.In.Reset := NOT (xOpMode.NetP);	
	
	xGEN2diag.In.bGasMixing_reset;
	xGEN2diag.In.rGasMixing_Ratio	:= IN_CB.rGT_RatioMix_TC2 * 100;

	xGEN2diag.In.Pset_norm			:= IN_CB.rP_Set_Norm; 		(*power reference trajectory [p.u.]*)
	xGEN2diag.In.Pset_WR_norm		:= IN_CB.rP_Set_GEN2_Norm; (* power reference without a ramp [p.u.]*)
	
	xGEN2diag.In.LambdaCmd 			:= IN_CB.rLam_Eng_LL_Set;

	xGEN2diag.In.p2s 				:= IN_CB.rPr_Ch_P2s_Avg_UF;	(*p2s [bar]*)
	xGEN2diag.In.p2sCmd 			:= IN_CB.rPr_Leanox_Set;	(*p2s command (LEANOX) [bar]*)
	
	xGEN2diag.In.posWG_norm 		:= IN_CB.rPos_Set_WG_Norm;	(*waste-gate position [p.u.] 0...1*)	
	xGEN2diag.In.WGM_reset;							(*reset bit for the wastegate monitoring part*)
	
	xGEN2diag.In.LEANOXErrorFiltReset;				(*reset bit for the lowpass used to filter p2s in the LEANOX error settling detection*)
	
	xGEN2diag.In.bVltg_reset;						(*reset bit for the voltage monitoring part*)
	
	IF Para.rU_Gen_Nom[1] <> 0 THEN					(* nomalize the voltage *)
		xGEN2diag.In.U_L1L2_norm 		:= IN_CB.tU_L1L2[1].Ai / Para.rU_Gen_Nom[1];
		xGEN2diag.In.U_L2L3_norm 		:= IN_CB.tU_L2L3[1].Ai / Para.rU_Gen_Nom[1];
		xGEN2diag.In.U_L3L1_norm 		:= IN_CB.tU_L3L1[1].Ai / Para.rU_Gen_Nom[1];
	END_IF

	xGEN2diag.In.bGCBON 			:= IN_CB.tGCB_On.Di;
	xGEN2diag.In.bMCBON 			:= IN_CB.tMCB_On.Di;
	
	FOR i := 1 TO xEngType.NumberOfCylinder DO
		xGEN2diag.In.Texh[i-1] 		:= IN_CB.rT_EG_Cyl[i];		(* exhaust temperatures *)
	END_FOR

	xGEN2diag.In.Lambda_ss			:= IN_CB.rLamSteadyState;	

	xGEN2diag.In.bTexhSettled_reset; 						(* reset bit for Texh settled detection (after power ramps) *)
	xGEN2diag.In.rITPmean := IN_CB.rCA_IgnP_Avg;			(* mean ignition timing point [°CA] *)

	(* monitor the inputs (leanox, Gride event and prechamber gas compressor *)

	(* check for parameter changes *)
	pm_len := SIZEOF(rDmyContainer);	(* measure the length to calulate the for loop *) (* 84 Byte // 21 Real PV´s *)
	ulChecksum := 0;					(* reset each time *)

	FOR iLoop := 0 TO 12 DO	(* loop over each datapackage *)

		ulOffset := 0;		(* reset of the offset *)

		CASE iLoop OF 		(* handle the worksplit *)
	
			1: 	memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.mp_a), SIZEOF(Para.mp_a)); ulOffset := ulOffset + SIZEOF(Para.mp_a);		(* 50 Bytes *)	

			3: 	memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.mp_b), SIZEOF(Para.mp_b)); ulOffset := ulOffset + SIZEOF(Para.mp_b);		(* 50 Bytes *)

			5: 	memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.rCA_Ign_OP_Start), SIZEOF(Para.rCA_Ign_OP_Start)); ulOffset := ulOffset + SIZEOF(Para.rCA_Ign_OP_Start);		(* 20 Bytes *)
			 	memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.rCA_Ign_OP_Power), SIZEOF(Para.rCA_Ign_OP_Power)); ulOffset := ulOffset + SIZEOF(Para.rCA_Ign_OP_Power);		(* 20 Bytes *)
			 	memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.rCA_Ign_OP_Speed), SIZEOF(Para.rCA_Ign_OP_Speed)); ulOffset := ulOffset + SIZEOF(Para.rCA_Ign_OP_Speed);		(* 20 Bytes *)
			
			7:  memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.tLeanox_Comp_IgnP), SIZEOF(Para.tLeanox_Comp_IgnP)); ulOffset := ulOffset + SIZEOF(Para.tLeanox_Comp_IgnP);		(* 16 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.bZZPKorr), SIZEOF(Para.bZZPKorr)); ulOffset := ulOffset + SIZEOF(Para.bZZPKorr);				(* 1 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.bt2Korr), SIZEOF(Para.bt2Korr)); ulOffset := ulOffset + SIZEOF(Para.bt2Korr);				(* 1 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.bDrehzkorr), SIZEOF(Para.bDrehzkorr)); ulOffset := ulOffset + SIZEOF(Para.bDrehzkorr);		(* 1 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.tLeanox_Comp_ChTmp), SIZEOF(Para.tLeanox_Comp_ChTmp)); ulOffset := ulOffset + SIZEOF(Para.tLeanox_Comp_ChTmp);		(* 16 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.rP_Eng_Frict), SIZEOF(Para.rP_Eng_Frict)); ulOffset := ulOffset + SIZEOF(Para.rP_Eng_Frict);			(* 4 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.rP_Nom_Gastype), SIZEOF(Para.rP_Nom_Gastype)); ulOffset := ulOffset + SIZEOF(Para.rP_Nom_Gastype);	(* 20 Bytes *) (* 59 *)
			
			9:	memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.usHu), SIZEOF(Para.usHu)); ulOffset := ulOffset + SIZEOF(Para.usHu);		(* 20 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.rMin_Air_Ratio), SIZEOF(Para.rMin_Air_Ratio)); ulOffset := ulOffset + SIZEOF(Para.rMin_Air_Ratio);		(* 40 Bytes *)

			11:	memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.usGasDensN), SIZEOF(Para.usGasDensN)); ulOffset := ulOffset + SIZEOF(Para.usGasDensN);		(* 20 Bytes *)
				memcpy(ADR(rDmyContainer) + ulOffset, ADR(Para.rPr_P2s_Set_LX_0kW), SIZEOF(Para.rPr_P2s_Set_LX_0kW)); ulOffset := ulOffset + SIZEOF(Para.rPr_P2s_Set_LX_0kW);		(* 40 Bytes *)
					
			2,4,6,8,10,12:
					FOR ulPMPointer := ADR(rDmyContainer) TO (ADR(rDmyContainer) + pm_len - SIZEOF(ulChkValue)) DO						(* split the dummy data container and  *)
						memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));														(* sum-up the values --> *)
						ulChecksum := ulChecksum + ulChkValue;																			(* due to the overflow the *)
					END_FOR;																											(* one-way function creats a unique result *)
		ELSE
			bParaChange := FALSE;				(* reset the first time *)
		END_CASE
	END_FOR

	IF ulChecksum <> ulChecksumOld THEN (* check for changes *)
		ulChecksumOld := ulChecksum;	(* log the new value *)	
		bParaChange := TRUE;			(* trigger the external settle time *)
	END_IF

	(* Leanox Controller *)
	bLeanoxChange := EDGEPOS(IN_CB.bLeanox_Man) OR EDGENEG(IN_CB.bLeanox_Man);
	bLeanoxM_Tgl := NOT xGEN2diag.In.bExt_dist AND IN_CB.bLeanox_Man; 					(* toggle as long as the leanox controller stays in manual mode *)
	
	(* Grid event *)
	bGrCChange := EDGEPOS(IN_CB.bMsg2831) OR EDGENEG(IN_CB.bMsg2831);

	(* PI Optimizer *)
	bPIOptiChange := EDGEPOS(IN_CB.bPIOptiChange);

	(* monitoring pressure prechamber gas compressor *)
	bPCGCChange := EDGEPOS(IN_CB.tPr_PCG_GC_Dem.Do) OR EDGENEG(IN_CB.tPr_PCG_GC_Dem.Do);

	(* PBC Misfire I or Misfire II bit *)
	bMisf_LGM := FALSE;
	FOR i := 1 TO xEngType.NumberOfCylinder DO
		IF IN_CB.bMisf_I[i] OR IN_CB.bMisf_II[i] THEN
			bMisf_LGM := TRUE;
		END_IF;
	END_FOR
	xTOF_Misf_LGM(IN := bMisf_LGM, PT := tiMisf_LGM);

	(* Sum-up the monitoring bits *)
	xGEN2diag.In.bExt_dist := bGEN2diag_Ext_dist := bParaChange OR bGrCChange OR bLeanoxChange OR bLeanoxM_Tgl OR bPIOptiChange OR IN_CB.bZylAusfallTP OR bPCGCChange OR IN_CB.bLX2_LGM_block OR xTOF_Misf_LGM.Q;
		
	xGEN2diag();
	
	bLGM_Event := (xGEN2diag.Out.FrictionFault) AND IN_CB.bGen2_NetP_ena; (* disable the observer alarms during service mode *)

	// trigger writing a file ONLY when a fault is detected during a power ramp -> appendix *_LGM_Ramp
	bLGM_Event_Ramp := (xGEN2diag.Out.FrictionFaultInTransient) AND IN_CB.bGen2_NetP_ena; 	(* disable the observer alarms during service mode *)
	
	bLamMon_DiagActive := xGEN2diag.dbgOut.DiagActive AND IN_CB.bGen2_NetP_ena;				(* diagnosis activated *)	

	(* hand over the data for HMI trending *)
	MM2VIS.bLam_Mon_DiagAct := bLamMon_DiagActive;
	MM2VIS.rLam_Mon_Grad   	:= xGEN2diag.dbgOut.Residual;
	MM2VIS.rLam_Mon_TexhMin := xGEN2diag.dbgOut.TexhMin;
	MM2VIS.rLam_Mon_TexhAvg := xGEN2diag.dbgOut.TexhAvg;

(****************************************************************************************************************************)

	IF Para.rN_EngNom < 950 THEN 	(* 60Hz *) 
		FricIMEP_P20.Para.PMEP_CC.P2_IP[0]	:= 1.35934; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[0] := -0.1897;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[1]	:= 2.126215; 		FricIMEP_P20.Para.PMEP_CC.PMEP_IP[1] := 0.0345;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[2]	:= 3.00711; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[2] := 0.2162;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[3]	:= 3.9498; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[3] := 0.3596;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[4]	:= 4.4309; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[4] := 0.4318;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[5]	:= 4.92023; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[5] := 0.512;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[6]	:= 5.41085; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[6] := 0.5814;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[7]	:= 5.417585; 		FricIMEP_P20.Para.PMEP_CC.PMEP_IP[7] := 0.5844;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[8]	:= 5.418; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[8] := 0.5845;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[9]	:= 5.419; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[9] := 0.5846;
	ELSE							(* 50Hz *)
		FricIMEP_P20.Para.PMEP_CC.P2_IP[0]	:= 1.31; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[0] := -0.2316;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[1]	:= 1.728569; 		FricIMEP_P20.Para.PMEP_CC.PMEP_IP[1] := -0.1229;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[2]	:= 2.17; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[2] := -0.0343;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[3]	:= 2.631067; 		FricIMEP_P20.Para.PMEP_CC.PMEP_IP[3] := 0.0383;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[4]	:= 3.1; 				FricIMEP_P20.Para.PMEP_CC.PMEP_IP[4] := 0.0992;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[5]	:= 3.590417; 		FricIMEP_P20.Para.PMEP_CC.PMEP_IP[5] := 0.1514;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[6]	:= 4.08; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[6] := 0.1943;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[7]	:= 4.58; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[7] := 0.2343;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[8]	:= 5.09; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[8] := 0.2815;
		FricIMEP_P20.Para.PMEP_CC.P2_IP[9]	:= 5.62; 			FricIMEP_P20.Para.PMEP_CC.PMEP_IP[9] := 0.3252;
	END_IF

	FricIMEP_P20.Para.NumberOfCylinder 		:= xEngType.NumberOfCylinder;		(* Engine no OF cylinders *)	
	FricIMEP_P20.Para.rInertia 		  		:= Para.rGen_Inertia; 				(* inertia of engine plus generator [kgm2] *)
	FricIMEP_P20.Para.rP_Nom	 			:= IN_CB.rP_Nom;
	FricIMEP_P20.Para.rNEngNom				:= Para.rN_EngNom;

	FricIMEP_P20.In.Speed 					:= IN_CB.rN_IgnSAFI_Act;			(* engine speed *)
	FricIMEP_P20.In.Pact 					:= IN_CB.tP_Act[1].Unfilt;	
	FricIMEP_P20.In.bGCBON 					:= IN_CB.tGCB_On.Di;
	FricIMEP_P20.In.bMCBON 					:= IN_CB.tMCB_On.Di;

	FricIMEP_P20.In.PF_Act  				:= IN_CB.tPF_Act[1].Ai;
	FricIMEP_P20.In.T_EO  					:= IN_CB.tT_EO.Ai;
	FricIMEP_P20.In.rPos_Set_WG_Norm;

	FricIMEP_P20.In.U_L1L2					:= IN_CB.tU_L1L2[1].Unfilt;
	FricIMEP_P20.In.U_L2L3					:= IN_CB.tU_L2L3[1].Unfilt;
	FricIMEP_P20.In.U_L3L1					:= IN_CB.tU_L3L1[1].Unfilt;

	FricIMEP_P20.In.I_L1					:= IN_CB.tI_L1[1].Unfilt;
	FricIMEP_P20.In.I_L2					:= IN_CB.tI_L2[1].Unfilt;
	FricIMEP_P20.In.I_L3					:= IN_CB.tI_L3[1].Unfilt;

	FricIMEP_P20.In.rPrChP2s  				:= IN_CB.rPr_Ch_P2s_Avg_UF;			(* unfiltered Average charge pressure p2' (after throttle valve) [bar] *)

	FricIMEP_P20.In.rPos_Set_WG_Norm		:= IN_CB.rPos_Set_WG_Norm; 			(* handover the setpoint for the waste gate position *)

	FricIMEP_P20.In.Reset_fastfilt := FricIMEP_P20.In.Reset_slowfilt := EDGEPOS(IN_CB.tGCB_On.Di) OR EDGENEG(IN_CB.tGCB_On.Di); 
	
	FricIMEP_P20.In.bExt_dist := EDGEPOS(IN_CB.bMsg2831) OR EDGENEG(IN_CB.bMsg2831); 	(* Grid event *)

	FOR i := 1 TO xEngType.NumberOfCylinder DO
		FricIMEP_P20.In.bPBCSensErr[i] 		:= IN_CB.bPBCSensErr[i];
		FricIMEP_P20.In.rPrIMEP[i] 			:= IN_CB.rPr_IMEP[i];
		FricIMEP_P20.In.bLimpHomeCyl[i] 	:= IN_CB.bLimpHomeCyl[i];
		FricIMEP_P20.In.bLimpHomeCylG2[i] 	:= IN_CB.bLimpHomeCylRKS[i];
		FricIMEP_P20.In.bLimpHomeCylExt[i] 	:= FALSE;
	END_FOR
	
	(*** IMEP Monitoring ***)
	FricIMEP_P20();

	bFMEP_Fault_Detection := FricIMEP_P20.Out.Fault_Diff AND Para.bFMEP_enable AND NOT (bGnlTrip AND IN_CB.tP_Act[1].Ai < (IN_CB.rP_Nom * 0.4));	(* hand-over to the MsgCB task *)

	OUT_CB.bFrictIMEP_Condition_On := FricIMEP_P20.dbgOut.Condition_ON AND Para.bFMEP_enable;

(****************************************************************************************************************************)


END_PROGRAM
