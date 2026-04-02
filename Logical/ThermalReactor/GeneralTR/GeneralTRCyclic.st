(*******************************************************************************
 GeneralTR	 			power limits and thresholds, controller increment/decrement, Operation hours, diagnostic visualization

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V04.00.00.00	03-04-2014	Denk/Ganguly	new
V04.03.00.00	25-09-2014  Denk,			adjust step controller for Thermal reactor 	
				29-06-2015  Denk,			Operation hour for Reactor, Gas Injection and el. Heater
v04.09.00.00	20-02-2020 	Denk,			Thermalreactor failure added
V04.12.00.00	12-05-2022	Maran			bugfix: updated triggering signal for electrical heater operating hour counter
				12-07-2022	Maran			bugfix: included warning conditions TRW05, TRW06 and TRW07 for thermalreactor failure(W9309)
V04.13.00.00	28-11-2023	Maran			Added MM2VIS variables and warnings for thermal reactor auxiliary gas injection monitoring
V04.14.00.00	27-11-2024	Maran			Added Thermal reactor high differential pressure monitoring - ThR2,
											 included ThR2 temperature signal faults on left and right chamber for thermalreactor failure(W9309)
				27-11-2024	Maran			Added Thermal reactor auxiliary gas solenoid valve fault monitoring - ThR2,
											 added Thermal reactor outlet/SCR inlet high differential pressure monitoring

Instructions for use:
--------------------

			
Outstandings: -
------------

(*******************************************************************************)


PROGRAM _CYCLIC
	
	(* Operating mode *)
	xOpMode(in := IN_TR.iSt_OpMode);
	
	(* Check is power limit exceeded for Thermal Reactor *)
	xGR_MAXR_P_TRACT.In := IN_TR.rP_Act_Norm_Filt  * IN_TR.rP_Nom;
	xGR_MAXR_P_TRACT.Gw := Para.rP_Norm_ThR_Active * IN_TR.rP_Nom;    (* Default 48%  *)
	xGR_MAXR_P_TRACT.Hy := Para.rP_ThR_ActiveHy;                      (* Default 20kW *)
	xGR_MAXR_P_TRACT();
	
	(* Thermal Reactor release if Net parallel and power threshold crossed *)
	bThR_Rel := xOpMode.NetP AND IN_TR.tPB2MM.bParaSetupOk AND xGR_MAXR_P_TRACT.Q;
	
	(* ThermalReactor Main task: Thermocouple failure, pressurized air failure, valve end position failure, heat up failure, control panel high temperature,
								 high temperature difference within TK1 or TK2, reactor temperature maximum, minimum temperature, operating switch and emission monitoring active *)
	bThR_Failure := 	Para.bThR_Active 
					AND bThR_Rel 
					AND (xTRW01.Q1 OR bThR2_T_fault_ReactChamber OR xTRW02.Q1 OR xTRW03.Q1 OR xTRW04.Q1 OR xTRW05.Q1 OR xTRW06.Q1 OR xTRW07.Q1 OR xTRW08.Q1 OR NOT IN_TR.tThR_Swth_On.Di)
					AND	Para.iIdx_Em_AvgMon_Option > 0;
	
	(* Operation hour counter - Thermalreactor running *)
	xBH_OpHour_Reactor(enable := OUT_TR.bThR_Run, BH_adr := ADR(OpHour_Reactor.tick));
	xR_TRIG_OpHour_Reactor(CLK := xBH_OpHour_Reactor.BH_Imp);
	
	IF xR_TRIG_OpHour_Reactor.Q THEN	(* if an operation hour is finished *)
		(* operating hour counter *)
		VIS2MM.iCnt_OpHours_Reactor := VIS2MM.iCnt_OpHours_Reactor + 1;		(* increase counter *)
		(* check limits *)
		IF VIS2MM.iCnt_OpHours_Reactor >= 1000000000 THEN
			VIS2MM.iCnt_OpHours_Reactor := VIS2MM.iCnt_OpHours_Reactor - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCnt_OpHours_Reactor <= -1000000000 THEN
			VIS2MM.iCnt_OpHours_Reactor := VIS2MM.iCnt_OpHours_Reactor + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	
	(* Operation hour counter - Gas injection *)
	xBH_OpHour_GasInj(enable := OUT_TR.bThR_RelGas, BH_adr := ADR(OpHour_GasInj.tick));
	xR_TRIG_OpHour_GasInj(CLK := xBH_OpHour_GasInj.BH_Imp);
	
	IF xR_TRIG_OpHour_GasInj.Q THEN	(* if an operation hour is finished *)
		(* operating hour counter *)
		VIS2MM.iCnt_OpHours_GasInj := VIS2MM.iCnt_OpHours_GasInj + 1;		(* increase counter *)
		(* check limits *)
		IF VIS2MM.iCnt_OpHours_GasInj >= 1000000000 THEN
			VIS2MM.iCnt_OpHours_GasInj := VIS2MM.iCnt_OpHours_GasInj - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCnt_OpHours_GasInj <= -1000000000 THEN
			VIS2MM.iCnt_OpHours_GasInj := VIS2MM.iCnt_OpHours_GasInj + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	
	(* Operation hour counter - Electrical heater *)
	xBH_OpHour_Heater(enable := bThR_elHeating, BH_adr := ADR(OpHour_Heater.tick));
	xR_TRIG_OpHour_Heater(CLK := xBH_OpHour_Heater.BH_Imp);
	
	IF xR_TRIG_OpHour_Heater.Q THEN	(* if an operation hour is finished *)
		(* operating hour counter *)
		VIS2MM.iCnt_OpHours_Heater := VIS2MM.iCnt_OpHours_Heater + 1;		(* increase counter *)
		(* check limits *)
		IF VIS2MM.iCnt_OpHours_Heater >= 1000000000 THEN
			VIS2MM.iCnt_OpHours_Heater := VIS2MM.iCnt_OpHours_Heater - 1000000000;		(* check upper limit *)
		ELSIF VIS2MM.iCnt_OpHours_Heater <= -1000000000 THEN
			VIS2MM.iCnt_OpHours_Heater := VIS2MM.iCnt_OpHours_Heater + 1000000000;		(* check lower limit *)
		END_IF;
	END_IF;
	
	(*  Thermal reactor auxiliary gas injection monitoring *)
	IF Para.bThR_auxGasMonitor THEN
		(* definition of running status for Th.Reactor aux.gas compressor *)
		MM2VIS.bThr_AuxGasCompressor_Run := OUT_TR.bThR_RelGas AND ((IN_TR.tPr_ThR_AuxGasBeforeCV.Ai >= rPr_ThR_AuxGas_thres_ComprRun) OR 
		(MM2VIS.bThr_AuxGasCompressor_Run AND (IN_TR.tPr_ThR_AuxGasBeforeCV.Ai >= rPr_ThR_AuxGas_thres_ComprRun - rPr_ThR_AuxGas_thres_ComprRunHy)));
	
		(* calculation of Th.Reactor aux.gas differential pressure *)
		MM2VIS.rPr_Diff_ThR_AuxGasCV := IN_TR.tPr_ThR_AuxGasBeforeCV.Ai - IN_TR.tPr_ThR_AuxGasAfterCV.Ai;
	
		(* calculation of estimated Th.Reactor aux.gas volume flow *)
		IF MM2VIS.bThr_AuxGasCompressor_Run THEN
			MM2VIS.rFlow_ThR_AuxGasCV := (MAX(0, IN_TR.tPos_ThR_AuxGasCV_Act.Ai) * (514 * Para.rThR_auxGasCV_Kv)) / SQRT((1.24 * 338.15) / LIMIT( 0.00001, (MAX(0, (MM2VIS.rPr_Diff_ThR_AuxGasCV / 1000)) * ((IN_TR.tPr_ThR_AuxGasAfterCV.Ai / 1000) + 1.01325)), 10)) ;
		ELSE
			MM2VIS.rFlow_ThR_AuxGasCV := 0;
		END_IF		
	ELSE
		MM2VIS.bThr_AuxGasCompressor_Run := FALSE;
		MM2VIS.rPr_Diff_ThR_AuxGasCV := 0;
		MM2VIS.rFlow_ThR_AuxGasCV := 0;
	END_IF
	(* Th.Reactor warning - auxiliary gas compressor fault *)
	xTON_ThR_AuxGasCompr_Fault(IN := Para.bThR_auxGasMonitor AND OUT_TR.bThR_RelGas AND NOT MM2VIS.bThr_AuxGasCompressor_Run AND IN_TR.tPr_ThR_AuxGasBeforeCV.GoodQual, PT := tiTON_ThR_AuxGasCompr_Fault);
	bThr_AuxGasCompressor_Fault := xTON_ThR_AuxGasCompr_Fault.Q;
	(* Th.Reactor warning - implausible auxiliary gas pressure before/after control valve *)
	xTON_ThR_AuxGasPr_PcheckFail(IN := Para.bThR_auxGasMonitor AND OUT_TR.bThR_RelGas AND (IN_TR.tPr_ThR_AuxGasAfterCV.Ai >= rPr_ThR_AuxGas_thres_ComprRun) AND (MM2VIS.rPr_Diff_ThR_AuxGasCV < 0) AND
	 IN_TR.tPr_ThR_AuxGasBeforeCV.GoodQual AND IN_TR.tPr_ThR_AuxGasAfterCV.GoodQual AND (NOT Para.bThR2_Ena OR OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do), PT := tiTON_ThR_AuxGasPr_PcheckFail);
	bThr_AuxGasPr_PcheckFail := xTON_ThR_AuxGasPr_PcheckFail.Q;
	
	(* Thermal reactor high differential pressure monitoring - ThR2 *)
	MM2VIS.rPr_Diff_ThR2 := IN_TR.tPr_ThR2_Inlet.Ai - IN_TR.tPr_ThR2_Outlet.Ai;
	xTON_ThR2_DPr_Hi(IN := Para.bThR2_Ena AND IN_TR.tPr_ThR2_Inlet.GoodQual AND IN_TR.tPr_ThR2_Outlet.GoodQual AND (MM2VIS.rPr_Diff_ThR2 > rDPr_ThR2_thres_Hi), PT := tiTON_ThR2_DPr_Hi);
	bThR2_DPr_Hi := xTON_ThR2_DPr_Hi.Q;
	
	(* Thermal Reactor auxiliary gas solenoid valve fault monitoring - ThR2 *)
	IF EDGENEG(OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do) THEN // record aux.gas pressure value at solenoid valve closing
		IF ((MM2VIS.rPr_Diff_ThR_AuxGasCV  >= rPr_ThR2_AuxGasValve_mon_inc + rPr_ThR2_AuxGasValve_mon_delta) AND IN_TR.tPr_ThR_AuxGasBeforeCV.GoodQual AND IN_TR.tPr_ThR_AuxGasAfterCV.GoodQual) THEN
			rPr_ThR2_AuxGasValve_mon_ref := IN_TR.tPr_ThR_AuxGasAfterCV.Ai;
			rPr_ThR2_AuxGasValve_mon_BefCV := IN_TR.tPr_ThR_AuxGasBeforeCV.Ai;
			bThR2_AuxGasValve_mon_valid := TRUE;
		ELSE
			bThR2_AuxGasValve_mon_valid := FALSE;
		END_IF
	END_IF
	xTOF_Thr2_AuxGasValve_mon_valid(IN := EDGENEG(OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do), PT := tiTON_Thr2_AuxGasValve_fault + T#500ms);
	IF (NOT OUT_TR.bThR_RelGas) OR (NOT xTOF_Thr2_AuxGasValve_mon_valid.Q) THEN //reset aux. gas solenoid valve fault monitoring if aux. gas system is stopped or check valid timer is elapsed
		bThR2_AuxGasValve_mon_valid := FALSE;
	END_IF
	xTON_Thr2_AuxGasValve_fault(IN := bThR2_AuxGasValve_mon_valid AND MM2VIS.bThr_AuxGasCompressor_Run AND NOT OUT_TR.tThR2_AuxGasShutOffValve_Dem.Do AND			(*pressure verification made during close command for aux. gas solenoid valve*)
	 ((IN_TR.tPr_ThR_AuxGasAfterCV.Ai <= rPr_ThR2_AuxGasValve_mon_ref + rPr_ThR2_AuxGasValve_mon_inc) AND IN_TR.tPr_ThR_AuxGasAfterCV.GoodQual) AND					(*pressure after CV - pressure increase verification*)
	 ((IN_TR.tPr_ThR_AuxGasBeforeCV.Ai >= rPr_ThR2_AuxGasValve_mon_BefCV - 0.6 * rPr_ThR2_AuxGasValve_mon_delta) AND IN_TR.tPr_ThR_AuxGasBeforeCV.GoodQual) AND		(*pressure before CV not decreased during the verification*)
	 ((IN_TR.tPos_ThR_AuxGasCV_Act.Ai >= rPos_ThR2_AuxGasValve_mon_valid) AND IN_TR.tPos_ThR_AuxGasCV_Act.GoodQual), PT := tiTON_Thr2_AuxGasValve_fault);			(*CV open position during the pressure verification*)
	bThr2_AuxGasValve_fault := xTON_Thr2_AuxGasValve_fault.Q;
	
	(* Exhaust aftertreatment: Thermal reactor outlet/SCR inlet high differential pressure monitoring - ThR2*)
	IF Para.bThR2_Ena AND ((Para.bSCR_Active OR Para.bSCR_Cust_Active) AND Para.bPr_SCR_CatIn_Exist) THEN
		MM2VIS.rPr_Diff_ThR2out_SCRin := IN_TR.tPr_ThR2_Outlet.Ai - (IN_TR.tPr_SCR_CatIn.Ai * 1000);
	ELSE
		MM2VIS.rPr_Diff_ThR2out_SCRin := 0;
	END_IF
	xTON_ThR2out_SCRin_DPr_Hi(IN := (MM2VIS.rPr_Diff_ThR2out_SCRin >= rDPr_ThR2_SCR_thres_Hi) AND IN_TR.tPr_ThR2_Outlet.GoodQual AND IN_TR.tPr_SCR_CatIn.GoodQual, PT := tiTON_ThR2out_SCRin_DPr_Hi);
	bThR2out_SCRin_DPr_Hi := xTON_ThR2out_SCRin_DPr_Hi.Q;
	
END_PROGRAM
