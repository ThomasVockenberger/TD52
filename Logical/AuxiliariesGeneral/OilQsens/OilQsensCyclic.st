(*******************************************************************************
OilQsens	Oil condition monitoring (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019 

- handle analog signals
- counter handling

Customized modifications: -
------------------------
 
History:
-------
V3.90.0	20.08.2013	Denk 		Created initial structured text code from V0.01.1 
V4.11.0	05.11.2021	Schmid		new oil quality sensor with CAN readout added
V4.11.1	04.02.2022	Schmid		reworked CAN oil configuration for 2nd generation OQS
V4.11.2	22.02.2022	Schmid		oil quality sensor modifications from validation
V4.12.0	12.10.2022	Bacci		oil quality sensor modification in accordance with TANDELTA firmware 4.03. Para.rT_OQS_LimLo and MM2VIS.iOQS_OC_Status_Num added. General user experience improvement
V4.13.0 27.09.2023 	Bacci		Flucon sensor clean-up

Instructions for use:
--------------------
- 
							
Outstandings:
------------
- Counter handling

*******************************************************************************)
PROGRAM _CYCLIC

(*TanDelta oil quality sensor*)
IF Para.iOQS_Config = 1 THEN
	
	IF VIS2MM.bOQS_OC_ConfigOilType THEN
		VIS2MM.bOQS_OC_ConfigOilType	:=	FALSE;
		iOQS_OC_ComState				:=	_CONFIG_OIL;
	END_IF;
	
	IF VIS2MM.bOQS_OC_ReadOilType THEN
		VIS2MM.bOQS_OC_ReadOilType		:=	FALSE;
		iOQS_OC_ComState				:=	_READ_CONFIG;
	END_IF;
	
	IF		VIS2MM.iOQS_OC_OilTypeIdx = 1 THEN		tOilConfig.sData_OilCfgUpd	:=	sStdOilCfg[1];
	ELSIF	VIS2MM.iOQS_OC_OilTypeIdx = 2 THEN		tOilConfig.sData_OilCfgUpd	:=	sStdOilCfg[2];
	END_IF;
	
	(*============================== CAN WRITE COMMANDS ===============================*)
	xCANwrite_OQS_OC.us_ident	:= IN_AG.iCAN_OQS_OC_us_ident;
	xCANwrite_OQS_OC.can_id		:= iSendMsgID_OC;
	xCANwrite_OQS_OC.data_adr	:= ADR(tDataSend_OC);
	xCANwrite_OQS_OC.data_lng	:= UDINT_TO_USINT(iDataLength_OC);
	
	IF iOQS_OC_ComState <> iOQS_OC_ComStateOld THEN
		bSend_OC			:= FALSE;
		iSendMsgCnt			:= 0;
	ELSE
		CASE iOQS_OC_ComState OF
			_READ_DATA:
				(*---------------------------- PREPARATION DATA REQUEST ----------------------------*)
				(* send data request *)
				IF iSendMsgCnt = 0 THEN
					iSendMsgCnt		:= 1;
					bSend_OC		:= TRUE;
				END_IF;
				IF bAck_OC THEN
					bSend_OC		:= TRUE;
					bAck_OC			:= FALSE;
				ELSIF xTON_AckMissing.Q THEN
					bSend_OC		:= TRUE;	// repeat send request
				END_IF;
				
				IF iSendMsgCnt < 4 THEN
					tDataSend_OC	:= tDataReq_OC;	// read data msg
					tDataSend_OC[3]	:= UINT_TO_BYTE(iSendMsgCnt);
				ELSE
					tDataSend_OC	:= tErrReq_OC;	// read error status msg
				END_IF;
				(*---------------------------- PREPARATION DATA REQUEST ----------------------------*)
				
				
			_CONFIG_OIL:
				(*---------------------------- BEGIN CONFIG OIL ---------------------------*)
				(* oil type reconfiguration *)
				(* write oil type configuration *)
				IF iSendMsgCnt = 0 THEN
					tDataSend_OC		:= tOilCfgWrite_Send_OC;
					tDataSend_OC[0]		:= tOilCfgWrite_SendB0_OC[iSendMsgCnt];
	
					xHexStr2ByteArr.iOffsetStrRd	:= 0;
					bSend_OC						:= TRUE;
				ELSE
					IF bAck_OC THEN
						bSend_OC	:= TRUE;
						bAck_OC		:= FALSE;
						
						xHexStr2ByteArr.pByteArray	:= ADR(tDataSend_OC[1]);
						xHexStr2ByteArr.pHexStr		:= ADR(tOilConfig.sData_OilCfgUpd);
						xHexStr2ByteArr.iLenByteWr	:= 7;
						xHexStr2ByteArr.iLenStrRd	:= iOQS_OC_OilCfg_CharSize;
						
						IF NOT ((iSendMsgCnt = 1) AND (xHexStr2ByteArr.iOffsetStrRd = 0)) THEN
							xHexStr2ByteArr.iOffsetStrRd	:= xHexStr2ByteArr.iOffsetStrRd + 2*xHexStr2ByteArr.iLenByteWr;
						END_IF;
						xHexStr2ByteArr();
					
						IF (UINT_TO_INT(iOQS_OC_OilCfg_CharSize) - UINT_TO_INT(xHexStr2ByteArr.iOffsetStrRd)) > 14 THEN
							tDataSend_OC[0] := tOilCfgWrite_SendB0_OC[iSendMsgCnt];
						ELSE
							tDataSend_OC[0] := 16#0B;
						END_IF;
					END_IF;
				END_IF;
				(*----------------------------- END CONFIG OIL ----------------------------*)
						
			
			_READ_CONFIG:
				(*--------------------------- BEGIN READ CONFIG ---------------------------*)
				(* oil type reconfiguration *)
				(* read oil type configuration *)
				IF iSendMsgCnt = 0 THEN
					tDataSend_OC	:= tOilCfgRead_Send_OC;
					bSend_OC		:= TRUE;
				ELSE
					IF bAck_OC THEN
						bSend_OC	:= TRUE;
						bAck_OC		:= FALSE;
					END_IF;
				END_IF;	
				tDataSend_OC[0]		:= tOilCfgRead_SendB0_OC[iSendMsgCnt];
				(*---------------------------- END READ CONFIG ----------------------------*)
				
		END_CASE;
	END_IF;
	
	xCANwrite_OQS_OC.enable	:= bSend_OC;
	xCANwrite_OQS_OC();
	
	(*---------------------------- PROCESS DATA REQUEST ----------------------------*)
	IF xCANwrite_OQS_OC.enable AND (xCANwrite_OQS_OC.status = 0) THEN
		bSend_OC	:=	FALSE;
	END_IF;
	(*---------------------------- PROCESS DATA REQUEST ----------------------------*)
	
	xTON_OQS_OC_WriteCommInterrupt(IN:= xCANwrite_OQS_OC.status <> 0, PT:= T#10s);	// write communication outage	
	(*=================================================================================*)

		
	
	(*=============================== CAN READ COMMANDS ===============================*)
	xCANread_OQS_OC.us_ident	:= IN_AG.iCAN_OQS_OC_us_ident;
	xCANread_OQS_OC.can_id		:= iRecMsgID_OC;
	xCANread_OQS_OC.data_adr	:= ADR(tDataRec_OC);
	
	IF iOQS_OC_ComState <> iOQS_OC_ComStateOld THEN
		bReceive_OC	:= FALSE;
	ELSE
		bReceive_OC	:= TRUE;
	END_IF;
	iOQS_OC_ComStateOld	:=	iOQS_OC_ComState;
	
	xCANread_OQS_OC.enable	:= bReceive_OC;
	xCANread_OQS_OC();
	
	IF xCANread_OQS_OC.enable AND (xCANread_OQS_OC.status = 0) THEN
		CASE iOQS_OC_ComState OF
			_READ_DATA:
				(*---------------------------- PROCESS DATA ----------------------------*)
				iReceiveID_OC	:=	SHL(BYTE_TO_UDINT(tDataRec_OC[0]), 24)
								+	SHL(BYTE_TO_UDINT(tDataRec_OC[1]), 16)
								+	SHL(BYTE_TO_UDINT(tDataRec_OC[2]), 8)
								+		BYTE_TO_UDINT(tDataRec_OC[3]);
				
				CASE iSendMsgCnt OF
					1:	bAck_OC	:=	(iReceiveID_OC = iID_OC_OilT);
					2:	bAck_OC	:=	(iReceiveID_OC = iID_OC_SensorT);
					3:	bAck_OC	:=	(iReceiveID_OC = iID_OC_OilCond);
					4:	bAck_OC	:=	(iReceiveID_OC = iID_OC_ErrStatus);
				ELSE	bAck_OC	:=	FALSE;
				END_CASE;
				
				IF bAck_OC THEN
					iSendMsgCnt	:= iSendMsgCnt + 1;
					IF iSendMsgCnt > 4 THEN
						iSendMsgCnt	:= 1;
					END_IF;
				END_IF;
								
				CASE iReceiveID_OC OF
					iID_OC_OilT:
						iT_Oil_OQS_OC	:=	SHL(BYTE_TO_UDINT(tDataRec_OC[7]), 24)
										+	SHL(BYTE_TO_UDINT(tDataRec_OC[6]), 16)
										+	SHL(BYTE_TO_UDINT(tDataRec_OC[5]), 8)
										+		BYTE_TO_UDINT(tDataRec_OC[4]);
						brsmemcpy(pDest:= ADR(MM2VIS.rT_Oil_OQS_OC), pSrc:= ADR(iT_Oil_OQS_OC), length:= 4);
					
					iID_OC_SensorT:
						iT_Sensor_OQS_OC	:=	SHL(BYTE_TO_UDINT(tDataRec_OC[7]), 24)
											+	SHL(BYTE_TO_UDINT(tDataRec_OC[6]), 16)
											+	SHL(BYTE_TO_UDINT(tDataRec_OC[5]), 8)
											+		BYTE_TO_UDINT(tDataRec_OC[4]);
						brsmemcpy(pDest:= ADR(MM2VIS.rT_Sensor_OQS_OC), pSrc:= ADR(iT_Sensor_OQS_OC), length:= 4);
												
					iID_OC_OilCond:
						iOilCond_OQS_OC	:=	SHL(BYTE_TO_UDINT(tDataRec_OC[7]), 24)
										+	SHL(BYTE_TO_UDINT(tDataRec_OC[6]), 16)
										+	SHL(BYTE_TO_UDINT(tDataRec_OC[5]), 8)
										+		BYTE_TO_UDINT(tDataRec_OC[4]);
						brsmemcpy(pDest:= ADR(rOilCond_OQS_OC), pSrc:= ADR(iOilCond_OQS_OC), length:= 4);
						rOilCond_OQS_OC	:=	rOilCond_OQS_OC / 100;										// Oil condition value convert to fraction instead of %
						
					iID_OC_ErrStatus:
						iErrStatus_OQS_OC :=	BYTE_TO_USINT(tDataRec_OC[4]);
				END_CASE;
				(*---------------------------- PROCESS DATA ----------------------------*)
		
				
			_CONFIG_OIL:
				(*---------------------- WAIT FOR ACKNOWLEDGEMENT ----------------------*)
				bAck_OC	:=	(brsmemcmp(pMem1:= ADR(tOilCfgWrite_RecB0_OC[iSendMsgCnt]), pMem2:= ADR(tDataRec_OC[0]), length:= 1) = 0)
						AND	(brsmemcmp(pMem1:= ADR(tOilCfgWrite_Rec_OC[1]), pMem2:= ADR(tDataRec_OC[1]), length:= 3) = 0);
				
				IF bAck_OC THEN
					iSendMsgCnt	:=	iSendMsgCnt + 1;
					IF iSendMsgCnt > 2 THEN
						iSendMsgCnt	:= 1;
					END_IF;
					
					IF (UINT_TO_INT(iOQS_OC_OilCfg_CharSize) - UINT_TO_INT(xHexStr2ByteArr.iOffsetStrRd)) < 14 THEN
						iOQS_OC_ComState	:=	_READ_CONFIG;
					END_IF;
				END_IF;
				(*---------------------- WAIT FOR ACKNOWLEDGEMENT ----------------------*)
			
				
			_READ_CONFIG:
				(*------------------------ READ OIL CONFIG DATA ------------------------*)
				IF iSendMsgCnt = 0 THEN
					bAck_OC	:=	(brsmemcmp(pMem1:= ADR(tOilCfgRead_RecB0_OC[iSendMsgCnt]), pMem2:= ADR(tDataRec_OC[0]), length:= 1) = 0)
							AND	(brsmemcmp(pMem1:= ADR(tOilCfgRead_Rec_OC[1]), pMem2:= ADR(tDataRec_OC[1]), length:= 7) = 0);
					
					xByteArr2HexStr.iOffsetByteRd	:= 0;
					xByteArr2HexStr.iOffsetStrWr	:= 0;
				ELSE
					bAck_OC	:=	(brsmemcmp(pMem1:= ADR(tOilCfgRead_RecB0_OC[iSendMsgCnt]), pMem2:= ADR(tDataRec_OC[0]), length:= 1) = 0);
					
					IF bAck_OC THEN	
						xByteArr2HexStr.pHexStr			:= ADR(tOilConfig.sData_OilCfgActive);
						xByteArr2HexStr.pByteArray		:= ADR(tDataRec_OC[1]);
						xByteArr2HexStr.iLenByteRd		:= 7;
						xByteArr2HexStr.iLenStrWr		:= iOQS_OC_OilSerialNr_CharSize;
						xByteArr2HexStr.iOffsetByteRd	:= 0;
						IF NOT ((iSendMsgCnt = 1) AND (xByteArr2HexStr.iOffsetStrWr = 0)) THEN
							xByteArr2HexStr.iOffsetStrWr	:= xByteArr2HexStr.iOffsetStrWr + 2*xByteArr2HexStr.iLenByteRd;
						END_IF;
						xByteArr2HexStr();
					END_IF;
				END_IF;
				
				IF bAck_OC THEN
					iSendMsgCnt	:=	iSendMsgCnt + 1;
					IF iSendMsgCnt > 2 THEN
						iSendMsgCnt	:= 1;
					END_IF;

					IF UINT_TO_INT(iOQS_OC_OilSerialNr_CharSize) - UINT_TO_INT(xByteArr2HexStr.iOffsetStrWr) <= 14 THEN
						iOQS_OC_ComState	:= _READ_DATA;
			
						IF 		tOilConfig.sData_OilCfgActive = sStdOilSerialNr[1] THEN	MM2VIS.iOQS_OC_OilTypeIdx	:=	1;
						ELSIF	tOilConfig.sData_OilCfgActive = sStdOilSerialNr[2] THEN	MM2VIS.iOQS_OC_OilTypeIdx	:=	2;
						ELSE															MM2VIS.iOQS_OC_OilTypeIdx	:=	0;
						END_IF;
					END_IF;
				END_IF;
				(*------------------------ READ OIL CONFIG DATA ------------------------*)
		END_CASE;
	ELSE
		bAck_OC	:=	FALSE;
	END_IF;
		
	xTON_AckMissing(IN:= NOT bAck_OC, PT:= T#5s);
	IF xTON_AckMissing.Q THEN
		iOQS_OC_ComState	:=	_READ_DATA;		// return to read state if acknowledgement is not registered on time
	END_IF;
	
	xTON_OQS_OC_ReadCommInterrupt(IN:= xCANread_OQS_OC.status <> 0, PT:= T#10s);	// read communication outage
	(*=================================================================================*)
	
	
	(* generate MSF warning *)
	xTON_OQS_OC_ValueErr(IN:= (rOilCond_OQS_OC < -0.2) OR (rOilCond_OQS_OC > 0.6), PT:= T#10s);

	bAMM_OQS_OC_MSF			:=	xTON_OQS_OC_ReadCommInterrupt.Q
							OR	xTON_OQS_OC_WriteCommInterrupt.Q
							OR	xTON_OQS_OC_ValueErr.Q
							OR	(iErrStatus_OQS_OC <> 0);
	
	(*_READ_CONFIG when measure signal failure is reset*)
	xF_TRIG_OQS_OC_MSFOff(CLK:= (bAMM_OQS_OC_MSF));
	IF xF_TRIG_OQS_OC_MSFOff.Q THEN
		iOQS_OC_ComState := _READ_CONFIG;
	END_IF;
	
	(*Update Old Oil Quality status*)
	IF NOT bAMM_OQS_OC_MSF AND (iOQS_OC_Status <> _iMeasSignalFailure) THEN
		iOQS_OC_StatusOld	:=	iOQS_OC_Status;
	END_IF;
	
	(* signal conditioning *)	
	(* oil quality signal value scaling *)
	xLCRScal_OilQual_OQS_OC.x		:=	rOilCond_OQS_OC;
	xLCRScal_OilQual_OQS_OC.x1		:=	Para.rOQS_OC_ScalAgedOil;
	xLCRScal_OilQual_OQS_OC.x2		:=	Para.rOQS_OC_ScalFreshOil;
	xLCRScal_OilQual_OQS_OC.y1		:=	0.0;
	xLCRScal_OilQual_OQS_OC.y2		:=	1.0;
	xLCRScal_OilQual_OQS_OC();
	rOilQual_OQS_OC					:=	LIMIT(-99.999, xLCRScal_OilQual_OQS_OC.y, 1.0);	// open end towards negative quality values
	
	MM2VIS.rOilCond_OQS_OC_Unfilt	:=	rOilCond_OQS_OC;
	MM2VIS.rOilQual_OQS_OC_Unfilt	:=	rOilQual_OQS_OC;
	
	(* filtering *)
	xGR_MAXR_T_Oil_OQS_OC(In:= MM2VIS.rT_Oil_OQS_OC, Gw:= Para.rT_OQS_LimLo, Hy:= 2.0);
	IF xGR_MAXR_T_Oil_OQS_OC.Q AND IN_AG.tEng_Run.Do THEN				// only log sensor values if oil temperature above threshold temperature - else freeze values
		xFILTER_OilCond_OQS_OC(In:= rOilCond_OQS_OC, Filter:= 6000);	// 10min filter time const. with 100ms cycle time
	END_IF;
	xLCRScal_OilQual_OQS_OC(x	:=	xFILTER_OilCond_OQS_OC.Out);
	MM2VIS.rOilQual_OQS_OC		:=	LIMIT(-99.999, xLCRScal_OilQual_OQS_OC.y, 1.0);	// open end towards negative quality values

	xTON_EngRun_1h(IN:= IN_AG.tEng_Run.Do, PT:= T#1h);
	
	(* tendency evaluation *)
	xTON_SecondTick(IN := NOT xTON_SecondTick.Q, PT := T#750ms);	// 750ms + 2 cycles = 950ms -> produces 1s tick due to 100ms sampling rate
	rOilQual_OQS_OC_1sSum := rOilQual_OQS_OC_1sSum + MM2VIS.rOilQual_OQS_OC;
	
	IF xTON_SecondTick.Q THEN
		rOilQual_OQS_OC_1sAvg		:=	rOilQual_OQS_OC_1sSum / 10;
		rOilQual_OQS_OC_1sSum		:=	0.0;
	END_IF;
	
	IF NOT bAMM_OQS_OC_MSF THEN
		xCTD_MinuteTick(CD:= xTON_SecondTick.Q, LOAD:= xCTD_MinuteTick.Q, PV:= 60);
		IF xTON_SecondTick.Q THEN
			rOilQual_OQS_OC_1mSum		:=	rOilQual_OQS_OC_1mSum + rOilQual_OQS_OC_1sAvg;
		END_IF;
		IF xCTD_MinuteTick.Q THEN
			rOilQual_OQS_OC_1mAvg		:=	rOilQual_OQS_OC_1mSum / 60;
			rOilQual_OQS_OC_1mSum		:=	0.0;
		END_IF;
		
		xCTD_HourTick(CD:= xCTD_MinuteTick.Q, LOAD:= xCTD_HourTick.Q, PV:= 60);
		IF xCTD_MinuteTick.Q THEN
			rOilQual_OQS_OC_1hSum		:=	rOilQual_OQS_OC_1hSum + rOilQual_OQS_OC_1mAvg;
		END_IF;
		IF xCTD_HourTick.Q THEN
			rOilQual_OQS_OC_1hAvg		:=	rOilQual_OQS_OC_1hSum / 60;
			rOilQual_OQS_OC_1hSum		:=	0.0;
		END_IF;
		
		IF xGR_MAXR_T_Oil_OQS_OC.Q AND xTON_EngRun_1h.Q THEN
			IF xCTD_HourTick.Q THEN
				IF (rOilQual_OQS_OC_Old > -100.0) THEN
					MM2VIS.rOilQualTendency_OQS_OC	:=	rOQS_OC_alpha * (rOilQual_OQS_OC_1hAvg - rOilQual_OQS_OC_Old) * 100 + (1 - rOQS_OC_alpha) * MM2VIS.rOilQualTendency_OQS_OC;	// % per 100 oph, negative if oil quality decreases
				END_IF;
				rOilQual_OQS_OC_Old					:=	rOilQual_OQS_OC_1hAvg;
			END_IF;
		ELSE
			MM2VIS.rOilQualTendency_OQS_OC			:=	0.0;
			rOilQual_OQS_OC_Old						:=	-999.9;
		END_IF;
	ELSE
		MM2VIS.rOilQualTendency_OQS_OC			:=	0.0;
		rOilQual_OQS_OC_Old						:=	-999.9;
	END_IF;
	
	(* generate warnings *)
	bOQS_OC_RelMon			:=	xTON_EngRun_1h.Q AND xGR_MAXR_T_Oil_OQS_OC.Q;
	
	IF xTON_OQS_Status_UsedGood.Q THEN	xGR_MINR_OQS_Status_UsedGood.Hy	:=	0.05;	(* trap oil quality status in hysteresis if value below limit for > 10min *)
	ELSE								xGR_MINR_OQS_Status_UsedGood.Hy	:=	0.0;
	END_IF;
	IF xTON_OilQual_ValueLo.Q THEN		xGR_MINR_OQS_Status_UsedBad.Hy	:=	0.05;
	ELSE								xGR_MINR_OQS_Status_UsedBad.Hy	:=	0.0;
	END_IF;
	IF xTON_OilQual_ValueLo1.Q THEN		xGR_MINR_OQS_Status_Old.Hy		:=	0.05;
	ELSE								xGR_MINR_OQS_Status_Old.Hy		:=	0.0;
	END_IF;
	
	xGR_MINR_OQS_Status_UsedGood(In:= MM2VIS.rOilQual_OQS_OC,	Gw:= Para.rOilQual_OQS_OC_LimLo + 0.2);
	xGR_MINR_OQS_Status_UsedBad	(In:= MM2VIS.rOilQual_OQS_OC,	Gw:= Para.rOilQual_OQS_OC_LimLo);
	xGR_MINR_OQS_Status_Old		(In:= MM2VIS.rOilQual_OQS_OC,	Gw:= Para.rOilQual_OQS_OC_LimLo1);
	
	xTON_OQS_Status_UsedGood(IN	:=	xGR_MINR_OQS_Status_UsedGood.Q,	PT:= T#10m);
	xTON_OilQual_ValueLo(IN		:=	xGR_MINR_OQS_Status_UsedBad.Q,	PT:= T#10m);
	bOilQual_ValueLo			:=	xTON_OilQual_ValueLo.Q	AND bOQS_OC_RelMon;
	bAMM_OQS_OC_ValueLo			:=	(EDGEPOS(xTON_OQS_Status_UsedGood.Q) AND bOQS_OC_RelMon)
								OR	bOilQual_ValueLo;										(*W9353 early oil quality warning*)
			
	xTON_OilQual_ValueLo1(IN	:=	xGR_MINR_OQS_Status_Old.Q,		PT:= T#10m);
	bOilQual_ValueLo1			:=	xTON_OilQual_ValueLo1.Q	AND bOQS_OC_RelMon;
	bAMM_OQS_OC_ValueLo1		:=	bOilQual_ValueLo1;										(*W9354 critical oil quality warning*)
	
	xTON_OilQualTendency_Hi(IN	:= (MM2VIS.rOilQualTendency_OQS_OC < Para.rOilQualTendency_OQS_OC_LimHi), PT := T#10s);
	bOilQualTendency_Hi			:=	xTON_OilQualTendency_Hi.Q AND bOQS_OC_RelMon;
	bAMM_OQS_OC_TendencyHi		:=	bOilQualTendency_Hi;									(*W9355 early oil qual. tendency warning*)
	
	xTON_OilQualTendency_Hi1(IN	:= (MM2VIS.rOilQualTendency_OQS_OC < Para.rOilQualTendency_OQS_OC_LimHi1), PT := T#10s);
	bOilQualTendency_Hi1		:=	xTON_OilQualTendency_Hi1.Q AND bOQS_OC_RelMon;
	bAMM_OQS_OC_TendencyHi1		:=	bOilQualTendency_Hi1;									(*W9356 critical oil qual. tendency warning*)
							
	(* generate oil quality status *)
	xTON_OQS_Status_RecoverUsedGood	(IN:= NOT xGR_MINR_OQS_Status_UsedGood.Q,	PT:= T#2h);
	xTON_OQS_Status_RecoverUsedBad	(IN:= NOT xGR_MINR_OQS_Status_UsedBad.Q,	PT:= T#2h);
	xTON_OQS_Status_RecoverOld		(IN:= NOT xGR_MINR_OQS_Status_Old.Q,		PT:= T#2h);
	xTON_OQS_Status_RecoverMSF		(IN:= NOT bAMM_OQS_OC_MSF,					PT:= T#1m); 	// faster recover process for MSF status 
	
	IF MM2VIS.bMsg9002 THEN
		xTON_OQS_Status_RecoverUsedGood(PT:= T#0s);
		xTON_OQS_Status_RecoverUsedBad(PT:= T#0s);
		xTON_OQS_Status_RecoverOld(PT:= T#0s);
	END_IF;
	
	IF 		bAMM_OQS_OC_MSF	THEN												iOQS_OC_Status	:=	_iMeasSignalFailure;
	ELSIF	MM2VIS.bMsg9356	THEN												iOQS_OC_Status	:=	_iOilQual_Old;
	ELSIF	MM2VIS.bMsg9355 AND (iOQS_OC_Status <> _iOilQual_Old) THEN			iOQS_OC_Status	:=	_iOilQual_UsedBad;
	END_IF;
	
	CASE iOQS_OC_Status OF
		_iMeasSignalFailure:
			IF xTON_OQS_Status_RecoverMSF.Q THEN								iOQS_OC_Status	:=	iOQS_OC_StatusOld;
			END_IF;
		_iOilQual_Old:
			IF xTON_OQS_Status_RecoverOld.Q AND NOT MM2VIS.bMsg9356 THEN		iOQS_OC_Status	:=	_iOilQual_UsedBad;
			END_IF;
		_iOilQual_UsedBad:
			IF	bOilQual_ValueLo1 THEN											iOQS_OC_Status	:=	_iOilQual_Old;
			ELSIF xTON_OQS_Status_RecoverUsedBad.Q AND NOT MM2VIS.bMsg9355 THEN	iOQS_OC_Status	:=	_iOilQual_UsedGood;
			END_IF;
		_iOilQual_UsedGood:
			IF	bOilQual_ValueLo THEN											iOQS_OC_Status	:=	_iOilQual_UsedBad;
			ELSIF xTON_OQS_Status_RecoverUsedGood.Q THEN						iOQS_OC_Status	:=	_iOilQual_New;
			END_IF;
		_iOilQual_New:
			IF	xTON_OQS_Status_UsedGood.Q THEN									iOQS_OC_Status	:=	_iOilQual_UsedGood;
			END_IF;
	END_CASE;
	
	MM2VIS.iOQS_OC_Status_Num	:=	iOQS_OC_Status;
	MM2VIS.iOQS_OC_Status		:=	iIdx_OQS_OC_Status_Colors[iOQS_OC_Status];
	
	(* manage oil sample interval *)
	IF iOQS_OC_Status =	_iOilQual_New THEN
		bOpMsg_ExtendOilSampleOh	:=	NOT VIS2MM.bOQS_OilSampleOh_Man;
		rOQS_OC_OilSampleMult		:=	2.0;
	ELSE
		bOpMsg_ExtendOilSampleOh	:=	FALSE;
		rOQS_OC_OilSampleMult		:=	1.0;
	END_IF;
	
	(* oil sample interval depending on oil quality status *)
	MM2VIS.iOQS_OilSampleOh	:=	REAL_TO_DINT(DINT_TO_REAL(Para.iOilSamplingNomOh) * rOQS_OC_OilSampleMult);
	
	(* adjust remaining time to next sample in case of status change *)
	xR_TRIG_OQS_OC_Status_Dec(CLK:= (iOQS_OC_Status <> _iOilQual_New));
	xR_TRIG_OQS_OC_Status_Inc(CLK:= (iOQS_OC_Status = _iOilQual_New));
	
	IF NOT VIS2MM.bOQS_OilSampleOh_Man THEN
		IF		xR_TRIG_OQS_OC_Status_Dec.Q THEN	MM2VIS.iCnt_OilSampleOh	:=	MM2VIS.iCnt_OilSampleOh/2;
		ELSIF	xR_TRIG_OQS_OC_Status_Inc.Q THEN	MM2VIS.iCnt_OilSampleOh	:=	MIN(MM2VIS.iCnt_OilSampleOh*2, MM2VIS.iOQS_OilSampleOh);
		END_IF;
	END_IF;

	
ELSE
	(* reset vars *)
	xCANwrite_OQS_OC(enable:= FALSE);
	xCANread_OQS_OC(enable:= FALSE);
	xTON_DataSend_ReqTick(IN:= FALSE);
	xTON_SecondTick(IN:= FALSE);
	xCTD_MinuteTick(LOAD:= TRUE);
	xCTD_HourTick(LOAD:= TRUE);
	xTON_EngRun_1h(IN:= FALSE);
	xTON_OQS_OC_WriteCommInterrupt(IN:= FALSE);
	xTON_OQS_OC_ReadCommInterrupt(IN:= FALSE);
	xTON_OQS_OC_ValueErr(IN:= FALSE);
	iErrStatus_OQS_OC := 0;
	MM2VIS.iOQS_OilSampleOh		:=	VIS2MM.iOilSampleOh;	(* default from manual setting *)
	rOQS_OC_OilSampleMult		:=	1.0;
	VIS2MM.bOQS_OilSampleOh_Man	:=	TRUE;
	xTON_OQS_Status_UsedGood(IN:= FALSE);
	xTON_OilQual_ValueLo(IN:= FALSE);
	xTON_OilQual_ValueLo1(IN:= FALSE);
	xTON_OilQualTendency_Hi(IN:= FALSE);
	xTON_OilQualTendency_Hi1(IN:= FALSE);
	xTON_OQS_Status_RecoverUsedGood(IN:= FALSE);
	xTON_OQS_Status_RecoverUsedBad(IN:= FALSE);
	xTON_OQS_Status_RecoverOld(IN:= FALSE);
	xTON_OQS_Status_RecoverMSF(IN:= FALSE);
	
	(* reset warnings *)
	bAMM_OQS_OC_ValueLo			:=	FALSE;
	bAMM_OQS_OC_ValueLo1		:=	FALSE;
	bAMM_OQS_OC_TendencyHi		:=	FALSE;
	bAMM_OQS_OC_TendencyHi1		:=	FALSE;
	bAMM_OQS_OC_MSF				:=	FALSE;
	bOpMsg_ExtendOilSampleOh	:=	FALSE;
END_IF;
	

	(*----------------------------------------------------------------------------------------*)
	(*========== BEGIN SAVE OIL QUALITY SENSOR OIL TYPE CONFIG IN PERMANENT MEMORY ===========*)

	(* 10 seconds timer *)
	xTON_WritePMEM(IN := NOT xTON_WritePMEM.Q, PT:= T#10s);
	xTON_BlockMinFileAge(IN := bBlock_MinFileAge, PT:= T#10m);
	IF xTON_BlockMinFileAge.Q THEN	bBlock_MinFileAge := FALSE; END_IF;

	(* every 10 seconds or at write once the parameter values are copied to the structure pm *)
	IF xTON_WritePMEM.Q OR write_once THEN
		(* ------------- V4.11 ---------------- *)
		pmOQS.sData_OilCfgActive	:= tOilConfig.sData_OilCfgActive;	(* copy parameter value to structure pm *)								
		pmOQS.sData_OilCfgUpd		:= tOilConfig.sData_OilCfgUpd;		(* ----------------- " ---------------- *)
	END_IF;

	(* cyclic calculation of parameter checksum	*)
	IF xTON_WritePMEM.Q THEN
		ulChecksum := 0;
		FOR ulPMPointer := ADR(pmOQS) TO (ADR(pmOQS) + pm_len - SIZEOF(ulChkValue)) DO
			memcpy(ADR(ulChkValue), ulPMPointer, SIZEOF(ulChkValue));
			ulChecksum := (ulChecksum XOR ulChkValue)+ulChkValue;
		END_FOR;
		IF ulChecksumOld <> ulChecksum THEN					(* if checksum has changed 		*)
			ulChecksumOld := ulChecksum;					(* save last checksum value		*)
			bWriteDataObj := TRUE;							(* set flag for write checksum	*)
		END_IF;
	END_IF;


	(* write structure pm to the permanent memory module *)
	IF ( (bWriteDataObj AND NOT bBlock_MinFileAge) OR write_once ) THEN
		DatObjWrite_01();									(* run data object write fub 					*)
		IF DatObjWrite_01.status <> ERR_FUB_BUSY THEN		(* wait if data object write fub is busy 		*)
			bWriteDataObj 	:= FALSE;						(* reset data object write flag					*)
			write_once 		:= FALSE;						(* reset write_once flag 						*)
			iPM_WriteCnt 	:= iPM_WriteCnt + 1;			(* counter for done data object module writes	*)	
			IF OUT_AG.tAG2PB.iPermStatus >=0 THEN 												(* new V4.06: if not already on error state, then transmit this perm status info *)
				OUT_AG.tAG2PB.iPermStatus := LIMIT(2, OUT_AG.tAG2PB.iPermStatus + 1, 999);		(* new V4.06: transmit OK= positive perm status info *)
				IF OUT_AG.tAG2PB.iPermStatus = 999 THEN OUT_AG.tAG2PB.iPermStatus := 2; END_IF;	(* new V4.06: transmit OK= positive perm status info *)
				OUT_AG.tAG2PB.bPermSetupOk := TRUE;												(* new V4.06: transmit perm status info *)
			END_IF;
			IF DatObjWrite_01.status = ERR_NOERROR THEN		(* if status = NO ERROR -> block further write requests for 10min to avoid CF wear down	*)
				bBlock_MinFileAge := TRUE;
			ELSE											(* if error status not no error 				*)
				pm_Error := 3005;  //:= 4;					(* set data object write error state			*)
			END_IF;
		END_IF;
	END_IF;
	

	(* set RPS warning if no access to SysRom file is possible *)	
	TON_WarnDelay(IN := pm_Error > 0 , PT:= T#15s);
	IF TON_WarnDelay.Q AND (OUT_AG.tAG2PB.iPermStatus >= 0) THEN 	OUT_AG.tAG2PB.iPermStatus := LIMIT(-999999,-UINT_TO_DINT(pm_Error) ,-1);	END_IF;	(* new V4.06: transmit error as negative perm status info *)
	IF (OUT_AG.tAG2PB.iPermStatus < 0) THEN 	OUT_AG.tAG2PB.bPermSetupOk := FALSE;	END_IF;		(* No reset of error bit - every error needs reboot *)		(* new V4.06: transmit perm status info *)

	(*=========== END SAVE OIL QUALITY SENSOR OIL TYPE CONFIG IN PERMANENT MEMORY ============*)	
	
END_PROGRAM