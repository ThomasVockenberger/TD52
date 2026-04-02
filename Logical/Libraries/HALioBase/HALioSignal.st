(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: HALioBase
 * File: HALioSignal.st
 * Author: froehlichw
 * Created: October 03, 2011
 ********************************************************************
 * Implementation of function block HALioSignal
 *
 * History:
 * 05.01.2012  V0.00.0 froehlichw
 *      (new)  created
 * 07.03.2012  V0.10.0 froehlichw
 *   (change)  Qual to GoodQual
 * 06.09.2012  V0.11.0 froehlichw
 *      (fix)  Range overflow at analog outputs
 * 30.07.2018  V0.13.1 Hohensinner
 *   (added)   Exist
 * 16.08.2021  V0.20.0 Weitzer
 *   (change)  UR20 types added
 * 25.01.2023  V0.22.0 Perktold
 *   (change)  Filter datatype
 * 31.01.2024  V0.23.0 Astner
 *   (change)  Added Exist to DI,AO,DO
 * 24.03.2025  V0.24.0 Astner
 *   (change)  Removed Exist from AO,DO
*******************************************************************)

FUNCTION_BLOCK HALioSignal

	(****************************************************
	* check FUB inputs
	****************************************************)
	isInput:= FALSE;
	isOutput:= FALSE;

	IF ParOK AND HwOK THEN
		status:= halERR_NO_ERROR;
	ELSE
		status:= halERR_FUB_NOT_ENABLED;
	END_IF;

	(* check signal type inputs *)
	IF (Type = DI_NORMAL) OR
		(Type = DI_NORMAL_INV) OR
		(Type = AI_0_10V_INT16) OR
		(Type = AI_0_20mA_INT16) OR
		(Type = AI_10_10V_INT16) OR
		(Type = AI_TEMP_1_10C) OR
		(Type = AI_INT8) OR
		(Type = AI_INT16) OR
		(Type = AI_INT32) OR
		(Type = DI_NORMAL_UR20) OR
		(Type = DI_NORMAL_INV_UR20) OR
		(Type = AI_0_10V_INT16_UR20) OR
		(Type = AI_0_20mA_INT16_UR20) OR
		(Type = AI_10_10V_INT16_UR20) OR
		(Type = AI_TEMP_1_10C_UR20) OR
		(Type = AI_INT8_UR20) OR
		(Type = AI_INT16_UR20) OR
		(Type = AI_INT32_UR20) THEN
		isInput:= TRUE;
	END_IF;
	(* check signal type outputs *)
	IF (Type = DO_NORMAL) OR
		(Type = AO_0_10V_INT16) OR
		(Type = AO_0_20mA_INT16) OR
		(Type = AO_10_10V_INT16) OR
		(Type = DO_NORMAL_UR20) OR
		(Type = AO_0_10V_INT16_UR20) OR
		(Type = AO_0_20mA_INT16_UR20) OR
		(Type = AO_10_10V_INT16_UR20) THEN
		isOutput:= TRUE;
	END_IF;
	(* is a valid signal type selected? *)
	IF isInput OR isOutput THEN
		(* yes => check pointer of signal-PV *)
		IF (pSignal <> 0) THEN
			(* check pointer of IO-PV *)
			IF (pPV_Name = 0) THEN
				(* pointer of IO-PV not valid => set error *)
				status:= halERR_INP_pPV_NAME_NV;
			END_IF;
		ELSE
			(* pointer of signal-PV not valid => set error *)
			status:= halERR_INP_pSIGNAL_NV;
		END_IF;
		(* check if intern or extern parameter are used *)
		IF (pExtern <> 0) THEN
			extPar ACCESS pExtern;
			IF (Qual_Min = 0) AND (Qual_Max = 0) THEN
				parUse.Qual_Min:= extPar.Qual_Min;
				parUse.Qual_Max:= extPar.Qual_Max;
			ELSE
				parUse.Qual_Min:= Qual_Min;
				parUse.Qual_Max:= Qual_Max;
			END_IF;
			IF (Scal_X1 = 0) AND (Scal_X2 = 0) THEN
				parUse.Scal_X1:= extPar.Scal_X1;
				parUse.Scal_X2:= extPar.Scal_X2;
			ELSE
				parUse.Scal_X1:= Scal_X1;
				parUse.Scal_X2:= Scal_X2;
			END_IF;
			IF (Scal_Y1 = 0) AND (Scal_Y2 = 0) THEN
				parUse.Scal_Y1:= extPar.Scal_Y1;
				parUse.Scal_Y2:= extPar.Scal_Y2;
			ELSE
				parUse.Scal_Y1:= Scal_Y1;
				parUse.Scal_Y2:= Scal_Y2;
			END_IF;
			IF (Filter <> 0) THEN
				parUse.Filter:= Filter;
			ELSE
				parUse.Filter:= extPar.Filter;
			END_IF;
		ELSE
			(* use intern parameter *)
			parUse.Qual_Min:= Qual_Min;
			parUse.Qual_Max:= Qual_Max;
			parUse.Scal_X1:= Scal_X1;
			parUse.Scal_X2:= Scal_X2;
			parUse.Scal_Y1:= Scal_Y1;
			parUse.Scal_Y2:= Scal_Y2;
			parUse.Filter:= Filter;
		END_IF;
	ELSE
		(* no valid signal type => set error *)
		status:= halERR_SIGNAL_TYPE_UNKNOWN;
	END_IF;

	TaskClass;	//remove compiler warning

	(****************************************************
	* handle inputs
	****************************************************)
	IF ((status = halERR_NO_ERROR) OR (status = halERR_FUB_NOT_ENABLED)) AND isInput THEN
		CASE Type OF
			(****************************************
			* handle digital inputs
			****************************************)
			DI_NORMAL,
			DI_NORMAL_UR20:
				din ACCESS pPV_Name;
				sigDi ACCESS pSignal;
				IF Active AND (status = halERR_NO_ERROR) THEN
					(* active *)
					sigDi.Di:= din;
					sigDi.GoodQual:= TRUE;
					sigDi.Exist := TRUE;
					(* message defined? *)
					IF (pMsg <> 0) THEN
						msg ACCESS pMsg;
						msg:= sigDi.Di;
					END_IF;
				ELSE
					(* not active *)
					sigDi.Di:= FALSE;
					sigDi.GoodQual:= FALSE;
					(* message defined? *)
					IF (pMsg <> 0) THEN
						msg ACCESS pMsg;
						msg:= FALSE;
					END_IF;
				END_IF;

			(****************************************
			* handle inverted digital inputs
			****************************************)
			DI_NORMAL_INV,
			DI_NORMAL_INV_UR20:
				din ACCESS pPV_Name;
				sigDi ACCESS pSignal;
				IF Active AND (status = halERR_NO_ERROR) THEN
					(* active *)
					sigDi.Di:= NOT din;
					sigDi.GoodQual:= TRUE;
					sigDi.Exist := TRUE;
					(* message defined? *)
					IF (pMsg <> 0) THEN
						msg ACCESS pMsg;
						msg:= sigDi.Di;
					END_IF;
				ELSE
					(* not active *)
					sigDi.Di:= FALSE;
					sigDi.GoodQual:= FALSE;
					sigDi.Exist := FALSE;
					(* message defined? *)
					IF (pMsg <> 0) THEN
						msg ACCESS pMsg;
						msg:= FALSE;
					END_IF;
				END_IF;

			(****************************************
			* handle analog inputs with REAL output
			****************************************)
			AI_0_20mA_INT16, AI_0_10V_INT16, AI_10_10V_INT16, AI_TEMP_1_10C,
			AI_0_20mA_INT16_UR20, AI_0_10V_INT16_UR20, AI_10_10V_INT16_UR20, AI_TEMP_1_10C_UR20:
				ain ACCESS pPV_Name;
				sigAi ACCESS pSignal;
				ainVal:= ain;
				IF Active AND (status = halERR_NO_ERROR) THEN
					(* active *)
					aiMinMax:= FALSE;
					(* check min and max value *)
					IF (parUse.Qual_Min <> parUse.Qual_Max) THEN
						IF (parUse.Qual_Min > parUse.Qual_Max) THEN
							status:= halERR_INP_QUAL_MIN_GT_MAX;
						END_IF;
						IF (ainVal < parUse.Qual_Min) OR (ainVal > parUse.Qual_Max) THEN
							aiMinMax:= TRUE;
						END_IF;
					ELSIF (parUse.Qual_Min <> 0) THEN
						aiMinMax:= TRUE;
						status:= halERR_INP_QUAL_MIN_EQ_MAX_NE_0;
					END_IF;
					(* message defined? *)
					IF (pMsg <> 0) THEN
						msg ACCESS pMsg;
						msg:= aiMinMax;
					END_IF;
					IF (Type = AI_TEMP_1_10C) OR (Type = AI_TEMP_1_10C_UR20) THEN
						sigAi.Unfilt:= DINT_TO_REAL(ainVal) / 10;
					ELSE
						(* check X parameter *)
						IF (parUse.Scal_X1 = parUse.Scal_X2) AND (parUse.Scal_X1 <> 0) THEN
							status:= halERR_INP_SCAL_X1_EQ_X2_NE_0;
						END_IF;
						(* check Y parameter *)
						IF (parUse.Scal_Y1 = parUse.Scal_Y2) AND (parUse.Scal_Y1 <> 0) THEN
							status:= halERR_INP_SCAL_Y1_EQ_Y2_NE_0;
						END_IF;
						sigAi.Unfilt:= HALioSigscalR(ainVal, parUse.Scal_X1, parUse.Scal_X2, parUse.Scal_Y1, parUse.Scal_Y2);
					END_IF;
					(* check Filter parameter *)
					IF (parUse.Filter = 0) THEN
						status:= halERR_INP_FILTER_EQ_0;
					END_IF;
					IF CycleTimeMs <> 0 THEN
						HALioFilterR_0(In:= sigAi.Unfilt, Filter:= INT_TO_REAL(parUse.Filter) / CycleTimeMs);
					ELSE
						HALioFilterR_0(In:= sigAi.Unfilt, Filter:= INT_TO_REAL(parUse.Filter));
					END_IF;
					sigAi.Ai:= HALioFilterR_0.Out;
					sigAi.GoodQual:= NOT aiMinMax;
					sigAi.Exist:= TRUE;
				ELSE
					(* not active *)
					sigAi.Ai:= 0.0;
					sigAi.Unfilt:= 0.0;
					sigAi.GoodQual:= FALSE;
					sigAi.Exist:= FALSE;
				END_IF;

			(****************************************
			* handle analog inputs with DINT output
			****************************************)
			AI_INT8, AI_INT16, AI_INT32,
			AI_INT8_UR20, AI_INT16_UR20, AI_INT32_UR20:
				IF (Type = AI_INT8) OR (Type = AI_INT8_UR20) THEN
					ain_INT8 ACCESS pPV_Name;
					ainVal:= ain_INT8;
				END_IF;
				IF (Type = AI_INT16) OR (Type = AI_INT16_UR20) THEN
					ain_INT16 ACCESS pPV_Name;
					ainVal:= ain_INT16;
				END_IF;
				IF (Type = AI_INT32) OR (Type = AI_INT32_UR20) THEN
					ain_INT32 ACCESS pPV_Name;
					ainVal:= ain_INT32;
				END_IF;
				sigAi_INT ACCESS pSignal;
				IF Active AND (status = halERR_NO_ERROR) THEN
					(* active *)
					aiMinMax:= FALSE;
					(* check min and max value *)
					IF (parUse.Qual_Min <> parUse.Qual_Max) THEN
						IF (parUse.Qual_Min > parUse.Qual_Max) THEN
							status:= halERR_INP_QUAL_MIN_GT_MAX;
						END_IF;
						IF (ainVal < parUse.Qual_Min) OR (ainVal > parUse.Qual_Max) THEN
							aiMinMax:= TRUE;
						END_IF;
					ELSIF (parUse.Qual_Min <> 0) THEN
						aiMinMax:= TRUE;
						status:= halERR_INP_QUAL_MIN_EQ_MAX_NE_0;
					END_IF;
					(* message defined? *)
					IF (pMsg <> 0) THEN
						msg ACCESS pMsg;
						msg:= aiMinMax;
					END_IF;
					(* check X parameter *)
					IF (parUse.Scal_X1 = parUse.Scal_X2) AND (parUse.Scal_X1 <> 0) THEN
						status:= halERR_INP_SCAL_X1_EQ_X2_NE_0;
					END_IF;
					(* check Y parameter *)
					IF (parUse.Scal_Y1 = parUse.Scal_Y2) AND (parUse.Scal_Y1 <> 0) THEN
						status:= halERR_INP_SCAL_Y1_EQ_Y2_NE_0;
					END_IF;
					sigAi_INT.Unfilt:= HALioSigscal(ainVal, parUse.Scal_X1, parUse.Scal_X2, REAL_TO_DINT(parUse.Scal_Y1), REAL_TO_DINT(parUse.Scal_Y2));
					(* check Filter parameter *)
					IF (parUse.Filter = 0) THEN
						status:= halERR_INP_FILTER_EQ_0;
					END_IF;
					HALioFilter_0(In:= sigAi_INT.Unfilt, Filter:= parUse.Filter);
					sigAi_INT.Ai:= HALioFilter_0.Out;
					sigAi_INT.GoodQual:= NOT aiMinMax;
					sigAi_INT.Exist:= TRUE;
				ELSE
					(* not active *)
					sigAi_INT.Ai:= 0;
					sigAi_INT.Unfilt:= 0;
					sigAi_INT.GoodQual:= FALSE;
					sigAi_INT.Exist:= FALSE;
				END_IF;
		END_CASE;
	END_IF;

	(****************************************************
	* handle outputs
	****************************************************)
	IF ((status = halERR_NO_ERROR) OR (status = halERR_FUB_NOT_ENABLED)) AND isOutput THEN
		CASE Type OF
			(****************************************
			* handle digital outputs
			****************************************)
			DO_NORMAL,
			DO_NORMAL_UR20:
				dout ACCESS pPV_Name;
				sigDo ACCESS pSignal;
				IF Active AND (status = halERR_NO_ERROR) THEN
					(* active *)
					dout:= sigDo.Do;
				END_IF

			(****************************************
			* handle analog outputs
			****************************************)
			AO_0_20mA_INT16, AO_0_10V_INT16, AO_10_10V_INT16,
			AO_0_20mA_INT16_UR20, AO_0_10V_INT16_UR20, AO_10_10V_INT16_UR20:
				aout ACCESS pPV_Name;
				sigAo ACCESS pSignal;
				IF Active AND (status = halERR_NO_ERROR) THEN
					(* active *)
					(* check X parameter *)
					IF (parUse.Scal_X1 = parUse.Scal_X2) AND (parUse.Scal_X1 <> 0) THEN
						status:= halERR_INP_SCAL_X1_EQ_X2_NE_0;
					END_IF;
					(* check Y parameter *)
					IF (parUse.Scal_Y1 = parUse.Scal_Y2) AND (parUse.Scal_Y1 <> 0) THEN
						status:= halERR_INP_SCAL_Y1_EQ_Y2_NE_0;
					END_IF;
					ainVal:= HALioSigscalRInv(sigAo.Ao, parUse.Scal_Y1, parUse.Scal_Y2, parUse.Scal_X1, parUse.Scal_X2);
					(* check range *)
					IF (ainVal > 32767) THEN
						aout:= 32767;
					ELSIF ((Type = AO_10_10V_INT16) OR (Type = AO_10_10V_INT16_UR20)) AND (ainVal < -32768) THEN
						aout:= -32768;
					ELSIF ((Type = AO_0_20mA_INT16) OR (Type = AO_0_10V_INT16) OR (Type = AO_0_20mA_INT16_UR20) OR (Type = AO_0_10V_INT16_UR20)) AND (ainVal < 0) THEN
						aout:= 0;
					ELSE
						aout:= DINT_TO_INT(ainVal);
					END_IF;
				END_IF;
		END_CASE;
	END_IF;
	
	
	(****************************************************
	* set IO system hardware type (0 = X20, 1 = UR20)
	****************************************************)
	IF (pExtern <> 0) THEN	
		IF (Type = DI_NORMAL_UR20) OR
			(Type = DI_NORMAL_INV_UR20) OR
			(Type = DO_NORMAL_UR20) OR
			(Type = AI_0_20mA_INT16_UR20) OR
			(Type = AI_0_10V_INT16_UR20) OR
			(Type = AI_10_10V_INT16_UR20) OR
			(Type = AI_TEMP_1_10C_UR20) OR
			(Type = AI_INT8_UR20) OR
			(Type = AI_INT16_UR20) OR
			(Type = AI_INT32_UR20) OR
			(Type = AO_0_20mA_INT16_UR20) OR
			(Type = AO_0_10V_INT16_UR20) OR
			(Type = AO_10_10V_INT16_UR20) THEN
			extPar.HW_Type := 1;
		ELSE
			extPar.HW_Type := 0;
		END_IF;
	END_IF;	
		
END_FUNCTION_BLOCK