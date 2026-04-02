(*******************************************************************************
ConRoMon: Conrod bearing temperature CANopen Sensor (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------
 
History:
-------
V0.1		27-05-2009	Kröll,Waldhart,Weigl generated
V0.11		22-03-2010	Waldhart,  	enhanced FOR 24 cylinder 
V0.11.1		17-11-2010	Waldhart,  	only FOR BR9 active
V0.12		10-06-2011	Waldhart,  	alarms over-worked
			01-08-2011	Waldhart,  	alarms over-worked
V0.12.1		18-08-2011	Waldhart,  	over-worked
V0.13		27.03.2013	Tinello 	restructured FOR modular SW
									add median monitoring
V0.14		14.01.2015	Tinello	 	restructured FOR XT4
V4.3		20.01.2016	Tinello		calibration and parametrization; read signal strength; 
									MIN, MAX and AVG for temperature and strength signal
V4.4		19.08.2016	Tinello		bugfix ACK A3378; 
			06.09.2016	Tinello		CANQueue, LowLoad and fault tolerant mode added --> Specification (d)
									message "conrod bearing temperature MEDIAN deviation maximum" (with bearing position) added
V4.5		27.01.2017	Tinello		Specification (e)
			17.05.2017	Tinello		Specification (e) + release after 60s with 400rpm
V4.05.01.00	07.03.2018	Tinello		Specification (f)
V4.05.03.00	12.09.2018	Tinello		Bugfix: Alarm bypass, bu
V4.07.00.00	28.03.2019	Tinello		Bugfix: power was compared to 30 instead of 0.3
V4.10.00.00	28.01.2021	Tinello  	BugFix: Timer & other FuB's

Instructions FOR use:
--------------------

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC

	(*--------------------------------------------------*)
	(* RESET of alarms and values	 					*)
	(*--------------------------------------------------*)
	bOpM_T_CBearing_Calib_Ok		:= FALSE;
	bWrongCylinder	 				:= FALSE;									(* reset wrong cylinder information bit *)

	rT_CBearing_Min					:= 10000;									(* reset min, max & avg temperature *)
	rT_CBearing_Max					:= 0;
	rT_CBearing_Sum					:= 0;

	iPc_T_CBearing_Sig_Min			:= 10000;									(* reset min, max & avg signal strength *)
	iPc_T_CBearing_Sig_Max			:= 0;
	iPc_T_CBearing_Sig_Sum			:= 0;

	iPc_T_CBearing_Gain_Min			:= 10000;									(* reset min, max & avg receiver gain level *)
	iPc_T_CBearing_Gain_Max			:= 0;
	iPc_T_CBearing_Gain_Sum			:= 0;

	iCntCB_MsOk						:= 0;										(* number of bearings with NO measurement error *)

	VIS2MM.iNum_T_CBearing_Calib	:= LIMIT(0, VIS2MM.iNum_T_CBearing_Calib, 20);


	(********************************************************************************************************************************)
	(************************             					 CAN communication				     	       **************************)
	(********************************************************************************************************************************)
	bRel_CBearing_CAN	:= Para.bT_CBearing_Exist	AND
						   NOT bAMM_T_CBearing_CAN	AND 						(* CAN bus communication - error *)
						   bRelModul_ParaSetupOk;
		

	(*--------------------------------------------------------------------------*)
	(* parametrization of kongsberg system per SDO's							*)
	(*--------------------------------------------------------------------------*)
	IF bAMM_T_CBearing_CAN THEN	 												(* send parameters again if CAN error *)
		iCnt_Para		:= 0;
		iSt_Para		:= 0;
		iCntCB_Para		:= 1;
	END_IF

	IF 	bRel_CBearing_CAN	AND													(* CAN bus released for read and write *)
		(iCnt_Para < 6) 			 											(* not all parameters have been transfered *)
	THEN
		(* load parameter settings *)
		CASE iCnt_Para OF
 			0:	(* Number of channels *)
				DATA_W.Address	:= 16#23;										(* 23 = WRITE with 4 databytes *)
				DATA_W.IndexHi	:= 16#21;
 				DATA_W.IndexLo	:= 16#02;
 				DATA_W.Data		:= 20;											(* 20 channels *)

  			1:	(* Minimum expected engine speed *)
				DATA_W.Address	:= 16#23;
				DATA_W.IndexHi	:= 16#21;
 				DATA_W.IndexLo	:= 16#01;
 				DATA_W.Data		:= 400;											(* 400 rpm *)

  			2:	(* Temperature value wenn sensor not detected *)
				DATA_W.Address	:= 16#23;
				DATA_W.IndexHi	:= 16#21;
 				DATA_W.IndexLo	:= 16#12;
 				DATA_W.Data		:= 1;											(* Temp = 0 if engine is not running *)
	
  			3:	(* High temperature alarm limit *)
				DATA_W.Address	:= 16#23;
				DATA_W.IndexHi	:= 16#20;
 				DATA_W.IndexLo	:= 16#09;
 				DATA_W.Data		:= 125;											(* 125 °C *)
				
			4:	(* HighHigh temperature alarm limit *)
				DATA_W.Address	:= 16#23;
				DATA_W.IndexHi	:= 16#20;
 				DATA_W.IndexLo	:= 16#0A;
 				DATA_W.Data		:= 130;											(* 130 °C *)

			5:	(* Delay before alarm output is set *)
				DATA_W.Address	:= 16#23;
				DATA_W.IndexHi	:= 16#20;
 				DATA_W.IndexLo	:= 16#0B;
 				DATA_W.Data		:= 0;											(* 0 sec. *)
		END_CASE

		(* prepare writing of parameters *)
		CASE iSt_Para OF
			0:	iSt_Para		:= 1;
			
			1:	(* write parameter *)
				xTON_WriteMax(IN:= FALSE);
				xTON_WriteAck(IN:= FALSE);
				iSt_Para		:= 2;
			
			2:	(* check parameter set *)
				IF iCnt_Para > 2 THEN
					xTON_WriteMax.PT	:= T#500ms;
					xTON_WriteAck.PT	:= T#300ms;
				ELSE
					xTON_WriteMax.PT 	:= T#6s;
					xTON_WriteAck.PT	:= T#5s;
				END_IF

				xTON_WriteMax(IN:= TRUE);										(* max time to acknowledge parameter set *)
				xTON_WriteAck(IN:= (DATA_R.Address  = 16#60) 	 		AND		(* timer to detect writing errors *)
							 	   (DATA_R.IndexHi  = DATA_W.IndexHi)	AND
								   (DATA_R.IndexLo  = DATA_W.IndexLo)	AND
								   (DATA_R.Cylinder = DATA_W.Cylinder)		);

				IF xTON_WriteAck.Q THEN

					(* parameter set was OK *)
					iSt_Para		:= 0;

					IF  (iCntCB_Para < xEngType.NumberOfCylinder) AND 
						(iCnt_Para 	 > 2)
					THEN
						iCntCB_Para	:= iCntCB_Para + 1;
					ELSE
						iCnt_Para 	:= iCnt_Para + 1;
						iCntCB_Para	:= 1;
					END_IF

				ELSIF xTON_WriteMax.Q THEN	
					iSt_Para		:= 1;										(* write parameter again *)
				END_IF
		END_CASE

		IF iCnt_Para > 2 THEN	DATA_W.Cylinder	:= iCntCB_Para;
						 ELSE	DATA_W.Cylinder	:= 0;							(* only one parameter for all cylinders *)
		END_IF
	ELSE
		xTON_WriteMax(IN:= FALSE);
		xTON_WriteAck(IN:= FALSE);
	END_IF


	(*--------------------------------------------------------------------------*)
	(* calibration of kongsberg system per SDO's								*)
	(*--------------------------------------------------------------------------*)
	IF	NOT bRel_CBearing_CAN								OR					(* CAN bus NOT released for read and write *)
		(iCnt_Para < 6) 		 							OR	  				(* parameter set NOT finished *)
		(iSt_ReadStrength > 0)								OR					(* reading of signal strength active *)
		MM2VIS.bMsg2794										OR					(* conrod bearing temp. calibration unsuccessful *)
		((IN_EG.rN_EngAct < 400) AND (iNumCB_Calib = 0))  	OR					(* calibration of all cyl. only during engine run *)
 		NOT VIS2MM.bDem_T_CBearing_Calib
	THEN
		VIS2MM.bDem_T_CBearing_Calib	:= FALSE;								(* reset demand *)

		iNumCB_Calib 			:= INT_TO_USINT(VIS2MM.iNum_T_CBearing_Calib);	(* bearing position not changeable during calibr. *)
		iSt_Calib				:= 0;
		iCntCB_Calib			:= 1;
	ELSE
		CASE iSt_Calib OF
			(* write calibration demand *)
			0:	DATA_W.Address	:= 16#23; 										(* 23 = WRITE with 4 databytes *)
				DATA_W.IndexHi	:= 16#20;										(* index 2021 = calibration of cable delay *)
				DATA_W.IndexLo	:= 16#21;
				DATA_W.Data		:= 1;											(* 1: start calibration *)
				iSt_Calib		:= 1;

			1:	IF (iCntCB_Calib < xEngType.NumberOfCylinder) AND 
				   (iNumCB_Calib = 0) 											(* 0 = calibrate all cylinders *)
				THEN
					iCntCB_Calib	:= iCntCB_Calib + 1;
				ELSE
					iCntCB_Calib	:= 1;
					iSt_Calib		:= 2;
				END_IF

			(* write read command: state of calibration *)
			2:	DATA_W.Address	:= 16#40; 										(* 40 = READ *)
				DATA_W.IndexHi	:= 16#20;										(* index 2002 = state *)
				DATA_W.IndexLo	:= 16#02;
				DATA_W.Data		:= 0;
				iSt_Calib		:= 3;

			3:	iSt_Calib		:= 4;

			(* read state of calibration *)
			4:	IF 	(DATA_R.Address  = 16#4F) 		AND
					(DATA_R.IndexHi  = 16#20) 		AND
					(DATA_R.IndexLo  = 16#02) 		AND
					(DATA_R.Cylinder = DATA_W.Cylinder)
				THEN
					MM2VIS.iSt_T_CBearing_Calib[DATA_R.Cylinder]	:= DATA_R.Data + 1;
					iSt_Calib		:= 3;

					IF (iCntCB_Calib < xEngType.NumberOfCylinder) AND
					   (iNumCB_Calib = 0) 										(* 0 = read status of all cylinders *)
					THEN
						iCntCB_Calib	:= iCntCB_Calib + 1;
					ELSE
						iCntCB_Calib	:= 1;
					END_IF
				END_IF

				IF xTON_Calibration.Q THEN  iSt_Calib	:= 5; END_IF

			(* check state of calibration after 120s *)
			5:	FOR i:= 1 TO xEngType.NumberOfCylinder DO
   					IF (MM2VIS.iSt_T_CBearing_Calib[i] = 4) OR
					   ((iNumCB_Calib <> i) AND (iNumCB_Calib <> 0))

					THEN 	bCalib_Again[i]	:= FALSE;
		  		  	ELSE	bCalib_Again[i]	:= TRUE;
							iSt_Calib		:= 6;
					END_IF
				END_FOR

				IF iSt_Calib = 5 THEN 
					VIS2MM.bDem_T_CBearing_Calib	:= FALSE; 					(* Calibration DONE - reset demand *)
					bReadStrength					:= TRUE;					(* Read signal strength after calibration *)
					bOpM_T_CBearing_Calib_Ok		:= TRUE;																(* B2909 *)
				END_IF

			(* write calibration demand AGAIN *)
			6:	DATA_W.Address	:= 16#23; 										(* 23 = WRITE with 4 databytes *)
				DATA_W.IndexHi	:= 16#20;										(* index 2021 = calibration of cable delay *)
				DATA_W.IndexLo	:= 16#21;
				DATA_W.Data		:= 1;											(* 1: start calibration *)

				iNumCalib_Again	:= 0;

				FOR i:= 1 TO xEngType.NumberOfCylinder DO
					IF	bCalib_Again[i] AND iNumCalib_Again = 0 THEN
						iNumCalib_Again	:= i;
						bCalib_Again[i]	:= FALSE;
					END_IF
				END_FOR

				IF iNumCalib_Again = 0 THEN iSt_Calib	:= 2; END_IF
		END_CASE


		IF iSt_Calib = 6			THEN	DATA_W.Cylinder	:= iNumCalib_Again;
		ELSIF (iNumCB_Calib = 0) 	THEN	DATA_W.Cylinder	:= iCntCB_Calib;
									ELSE	DATA_W.Cylinder	:= iNumCB_Calib;
		END_IF
	END_IF

	xTON_Calibration(IN		:= iSt_Calib > 1, PT:= T#180s);
	bAMM_T_CBearing_Calib	:= Para.bT_CBearing_Exist AND xTON_Calibration.Q;												(* W2794 *)


	(*--------------------------------------------------------------------------*)
	(* read signal strength and signal gain factor per SDO's					*)
	(*--------------------------------------------------------------------------*)
	xTON_ReadStrength(IN:= IN_EG.rN_EngAct >= Para.rN_EngNom * 0.95, PT:= T#2h);

	IF 	xTON_ReadStrength.Q															OR		(* read - every 2h *)
		EDGEPOS( IN_EG.rN_EngAct >= Para.rN_EngNom * 0.95) 							OR 		(* read - at engine start *)
		EDGENEG((IN_EG.rN_EngAct >= Para.rN_EngNom * 0.95) AND IN_EG.bEng_Aux_Dem)			(* read - at engine stop *)
	THEN 
		bReadStrength		:= TRUE;
		xTON_ReadStrength(IN:= FALSE);
	END_IF

	IF EDGENEG(IN_EG.rN_EngAct > Para.rN_EngNom * 0.4) THEN  bReadStrength	:= FALSE;	END_IF


	IF	bRel_CBearing_CAN		AND												(* CAN bus released for read and write *)
		(iCnt_Para >= 6) 		AND	 											(* all parameters have been transfered *)
		(iSt_Calib =  0)		AND												(* calibration not active *)
	 	bReadStrength
	THEN
		CASE iSt_ReadStrength OF
			(* write read command: strength of the signal from the sensor *)
			0:	DATA_W.Address		:= 16#40; 									(* 40 = READ *)
				DATA_W.IndexHi		:= 16#20;									(* index 2006 = strength of signal *)
				DATA_W.IndexLo		:= 16#06;
				DATA_W.Data			:= 0;
				iSt_ReadStrength	:= 1;

			1:	iSt_ReadStrength	:= 2;
			
			(* read strength of signal *)
			2:	IF 	(DATA_R.Address  = 16#4F) 		AND
					(DATA_R.IndexHi  = 16#20) 		AND
					(DATA_R.IndexLo  = 16#06) 		AND
					(DATA_R.Cylinder = DATA_W.Cylinder)	
				THEN
					iPc_T_CBearing_Sig_Act[DATA_R.Cylinder].Act[iCntCB_ReadAct]	:= DATA_R.Data;
				
					iSt_ReadStrength		:= 1;								(* write next read command *)

					IF (iCntCB_Read < xEngType.NumberOfCylinder)
					THEN
						iCntCB_Read			:= iCntCB_Read + 1;
					ELSE
						iCntCB_Read			:= 1;
						iCntCB_ReadAct		:= iCntCB_ReadAct + 1;

						IF iCntCB_ReadAct > 10 THEN

							FOR i:= 1 TO xEngType.NumberOfCylinder BY 1 DO
					
								iPc_T_CBearing_Sig_ActSum		:= 0;
					
								FOR ii:= 1 TO 10 DO
									iPc_T_CBearing_Sig_ActSum	:= iPc_T_CBearing_Sig_ActSum + iPc_T_CBearing_Sig_Act[i].Act[ii];
								END_FOR
					
								MM2VIS.iPc_T_CBearing_Sig[i]	:= iPc_T_CBearing_Sig_ActSum / 10;
							END_FOR
							
							iSt_ReadGain 		:= 1;							(* start reading the receiver gain level *)
							iCntCB_Read			:= 1;
							iCntCB_ReadAct		:= 1;

							iSt_ReadStrength	:= 3;							(* reading of signal strength done *)
						END_IF
					END_IF
				END_IF

			(* reading of signal strength done *)
			3:	iSt_ReadStrength	:= 3;
		END_CASE


		CASE iSt_ReadGain OF
			(* wait until reading of signal strength done *)
			0:	iSt_ReadGain		:= 0;

			(* write read command: receiver gain level *)
			1:	DATA_W.Address		:= 16#40; 									(* 40 = READ *)
				DATA_W.IndexHi		:= 16#20;									(* index 2005 = receiver gain level *)
				DATA_W.IndexLo		:= 16#05;
				DATA_W.Data			:= 0;
				iSt_ReadGain		:= 2;

			2:	iSt_ReadGain		:= 3;
			
			(* read receiver gain level *)
			3:	IF 	(DATA_R.Address  = 16#4F) 		AND
					(DATA_R.IndexHi  = 16#20) 		AND
					(DATA_R.IndexLo  = 16#05) 		AND
					(DATA_R.Cylinder = DATA_W.Cylinder)	
				THEN
					iPc_T_CBearing_Gain_Act[DATA_R.Cylinder].Act[iCntCB_ReadAct]	:= DATA_R.Data;
				
					iSt_ReadGain			:= 2;								(* write next read command *)

					IF (iCntCB_Read < xEngType.NumberOfCylinder)
					THEN
						iCntCB_Read			:= iCntCB_Read + 1;
					ELSE
						iCntCB_Read			:= 1;
						iCntCB_ReadAct		:= iCntCB_ReadAct + 1;

						IF iCntCB_ReadAct > 10 THEN

							FOR i:= 1 TO xEngType.NumberOfCylinder BY 1 DO
					
								iPc_T_CBearing_Gain_ActSum		:= 0;
					
								FOR ii:= 1 TO 10 DO
									iPc_T_CBearing_Gain_ActSum	:= iPc_T_CBearing_Gain_ActSum + iPc_T_CBearing_Gain_Act[i].Act[ii];
								END_FOR
					
								MM2VIS.iPc_T_CBearing_Gain[i]	:= iPc_T_CBearing_Gain_ActSum / 10;
							END_FOR
							
							bReadStrength 	:= FALSE;
						END_IF
					END_IF
				END_IF
		END_CASE

		DATA_W.Cylinder		:= iCntCB_Read;
	ELSE
		(* reset *)
		iSt_ReadStrength	:= 0;
		iSt_ReadGain		:= 0;
		iCntCB_Read			:= 1;
		iCntCB_ReadAct		:= 1;
	END_IF


	(*--------------------------------------------------------------------------*)
	(* CAN BUS - WRITE & READ													*)
	(*--------------------------------------------------------------------------*)
	(* write demand to kongsberg system *)
	IF (iSt_Para  = 1) OR 
	   (iSt_Calib = 1) OR (iSt_Calib = 3) OR (iSt_Calib = 6) OR
	   (iSt_ReadStrength = 1)								 OR
	   (iSt_ReadGain = 2)
	THEN
		xCANwrite_CB_Data.enable 	:= TRUE;
		xCANwrite_CB_Data.us_ident	:= IN_EG.iCAN_CB_us_ident;
		xCANwrite_CB_Data.can_id	:= 16#604;									(* set can identifier (600 plus Node-ID) *)
		xCANwrite_CB_Data.data_adr	:= ADR(DATA_W);
		xCANwrite_CB_Data.data_lng	:= 8;
		xCANwrite_CB_Data();
	END_IF
	
	(* read the acknowledge info *)
	IF (iSt_Para = 2) OR (iSt_Calib = 4) OR (iSt_ReadStrength = 2) OR (iSt_ReadGain = 3)
	THEN
		xCANread_CB_Data.enable 	:= TRUE;
		xCANread_CB_Data.us_ident	:= IN_EG.iCAN_CB_us_ident;
		xCANread_CB_Data.can_id		:= 16#584;									(* set can identifier (580 plus Node-ID) *)
		xCANread_CB_Data.data_adr	:= ADR(DATA_R);
		xCANread_CB_Data();
	END_IF	




	(*--------------------------------------------------------------------------*)
	(* Read conrod bearing temperature via PDO's	 							*)
	(*--------------------------------------------------------------------------*)
	memset(ADR(TEMP), 0, SIZEOF(TEMP));											(* clear received data *)

	IF (IN_EG.iCAN_CB_us_ident <> 0) AND NOT bQueueInitDone THEN
		(* generate CANqueue *)
		xCANqueue_CB_Temp.enable	:= TRUE;
		xCANqueue_CB_Temp.us_ident	:= IN_EG.iCAN_CB_us_ident;					(* set us_ident with the value from CANopen *)
		xCANqueue_CB_Temp.can_id	:= 16#184;									(* set can identifier (180 plus Node-ID) *)
		xCANqueue_CB_Temp.size		:= 100;										(* number of telegrams in the queue *)
		xCANqueue_CB_Temp;
		
		IF xCANqueue_CB_Temp.status = 0 THEN
			bQueueInitDone	:= TRUE;
		END_IF	
	END_IF

	IF xCANqueue_CB_Temp.us_ident <> 0 THEN
		(* read CANqueue *)
		xCANrd_CB_Temp.enable	:= TRUE;
		xCANrd_CB_Temp.q_ident	:= xCANqueue_CB_Temp.q_ident;					(* set q_ident with the value from CANqueue *)
		xCANrd_CB_Temp.data_adr	:= ADR(TEMP);									(* set data address *)
		xCANrd_CB_Temp();
	ELSE
		xCANrd_CB_Temp(enable	:= FALSE);
	END_IF

	CASE TEMP.Cylinder OF
		0: 																		(* wait for new data		*)
		1:	rT_CBearing[1]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  1	*)
		2:	rT_CBearing[2]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  2 	*)
		3:	rT_CBearing[3]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  3 	*)
		4:	rT_CBearing[4]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  4 	*)
		5:	rT_CBearing[5]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  5 	*)
		6:	rT_CBearing[6]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  6 	*)
		7:	rT_CBearing[7]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  7 	*)
		8:	rT_CBearing[8]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  8 	*)
		9:	rT_CBearing[9]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder  9 	*)
		10:	rT_CBearing[10]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 10 	*)
		11:	rT_CBearing[11]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 11 	*)
		12:	rT_CBearing[12]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 12 	*)
		13:	rT_CBearing[13] 	:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 13 	*)
		14:	rT_CBearing[14]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 14 	*)
		15:	rT_CBearing[15]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 15 	*)
		16:	rT_CBearing[16]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 16 	*)
		17:	rT_CBearing[17]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 17 	*)
		18:	rT_CBearing[18]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 18 	*)
		19:	rT_CBearing[19]		:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 19 	*)
		20:	rT_CBearing[20] 	:= UINT_TO_REAL(TEMP.Data);						(* temperature cylinder 20 	*)

		ELSE
			bWrongCylinder		:= bRelModul_ParaSetupOk;						(* wrong cylinder information *)
	END_CASE


	(*--------------------------------------------------*)
	(* Monitoring of CAN communication					*)
	(*--------------------------------------------------*)
	xTON_CANread(IN:= (xCANrd_CB_Temp.status <> 0) AND bRelModul_ParaSetupOk AND NOT IN_EG.tAB2EG.bResetWarning, PT:= T#10s);
	xTON_CANopen(IN:= (IN_EG.iCAN_CB_us_ident = 0) AND bRelModul_ParaSetupOk AND NOT IN_EG.tAB2EG.bResetWarning, PT:= T#10s);
	xTON_ParaSet(IN:= (iCnt_Para < 6) 			   AND bRelModul_ParaSetupOk AND NOT IN_EG.tAB2EG.bResetWarning, PT:= T#80s);

	bAMM_T_CBearing_CAN	:= Para.bT_CBearing_Exist  AND (xTON_CANopen.Q OR xTON_CANread.Q OR 								(* A2229 *)
												 	    xTON_ParaSet.Q OR bWrongCylinder);	





	(********************************************************************************************************************************)
	(************************     	         Monitoring of conrod bearing temperature			           **************************)
	(********************************************************************************************************************************)
	FOR iCntCB:= 1 TO xEngType.NumberOfCylinder BY 1 DO
	
		(* actual temperature *)
		MM2VIS.rT_CBearing[iCntCB]			:= rT_CBearing[iCntCB];				(* visu *)
		OUT_EG.rT_CBearing[iCntCB]			:= rT_CBearing[iCntCB];				(* OUT interface - For other modules *)

		(* search for signal strength MIN, MAX, SUM --> AVG *)
		iPc_T_CBearing_Sig_Min				:= MIN(iPc_T_CBearing_Sig_Min,  MM2VIS.iPc_T_CBearing_Sig[iCntCB]);
		iPc_T_CBearing_Sig_Max				:= MAX(iPc_T_CBearing_Sig_Max,  MM2VIS.iPc_T_CBearing_Sig[iCntCB]);
		iPc_T_CBearing_Sig_Sum				:= iPc_T_CBearing_Sig_Sum   +   MM2VIS.iPc_T_CBearing_Sig[iCntCB];

		(* search for receiver gain level MIN, MAX, SUM --> AVG *)
		iPc_T_CBearing_Gain_Min				:= MIN(iPc_T_CBearing_Gain_Min, MM2VIS.iPc_T_CBearing_Gain[iCntCB]);
		iPc_T_CBearing_Gain_Max				:= MAX(iPc_T_CBearing_Gain_Max, MM2VIS.iPc_T_CBearing_Gain[iCntCB]);
		iPc_T_CBearing_Gain_Sum				:= iPc_T_CBearing_Gain_Sum   +  MM2VIS.iPc_T_CBearing_Gain[iCntCB];


		(* Only intact signals used for calculation *)
		IF rT_CBearing[iCntCB] > 5 THEN				
			iCntCB_MsOk						:= iCntCB_MsOk + 1;					(* number of bearings without measurement error *)

			(* search for bearing temperature MIN, MAX, SUM --> AVG *)
			rT_CBearing_Min					:= MIN(rT_CBearing_Min, rT_CBearing[iCntCB]);
			rT_CBearing_Max					:= MAX(rT_CBearing_Max, rT_CBearing[iCntCB]);
			rT_CBearing_Sum					:= rT_CBearing_Sum   +  rT_CBearing[iCntCB];


			(* temperature median calculation *)
			xMEDIAN_Temp.in[iCntCB_MsOk]	:= rT_CBearing[iCntCB];
		END_IF
	END_FOR


	(* Create MEDIAN *)
	xMEDIAN_Temp.anzahl		:= iCntCB_MsOk;
	xMEDIAN_Temp();


	(* error monitoring *)
	xGR_MINR_T_EO(In:= IN_EG.tT_EO.Ai, Gw:= 65, Hy:= 5); 						(* hyst. = 5 °C *)		
	xGR_MAXR_T_EO(In:= IN_EG.tT_EO.Ai, Gw:= 65, Hy:= 5);						(* hyst. = 5 °C *)		

		IF EDGEPOS(xGR_MINR_T_EO.Q) OR EDGENEG(xGR_MAXR_T_EO.Q) THEN	bAdd_CBearing_Hi_Offset	:= FALSE; 	END_IF
		IF EDGENEG(xGR_MINR_T_EO.Q) OR EDGEPOS(xGR_MAXR_T_EO.Q) THEN	bAdd_CBearing_Hi_Offset	:= TRUE; 	END_IF


	FOR iCntCB:= 1 TO xEngType.NumberOfCylinder BY 1 DO

		IF  NOT Para.bT_CBearing_Exist 									OR
			(VIS2MM.bDem_T_CBearing_Calib AND (iNumCB_Calib = 0 	OR	 		(* all cylinders gets calibrated *)
									   		   iNumCB_Calib = iCntCB  ))
		THEN 
			bErrCBTemp_Ms[iCntCB]			:= FALSE;
			bErrCBTemp_Hi[iCntCB]			:= FALSE;
			bErrCBTemp_HiHi[iCntCB]			:= FALSE;
			bErrCBTempMDev_Lo[iCntCB]		:= FALSE;
			bErrCBTempMDev_HiHi[iCntCB]		:= FALSE;
			bErrCBTempSig_Lo[iCntCB] 		:= FALSE;
			xTON_MsDelay[iCntCB](IN			:= FALSE);
		ELSE
			(* MEASUREMENT ERROR *)
			xTON_MsDelay[iCntCB](IN			:= rT_CBearing[iCntCB] <= 5 AND xTON_ReleaseMon.Q,
								 PT			:= T#45s);

			bErrCBTemp_Ms[iCntCB]			:= xTON_MsDelay[iCntCB].Q;


			(* MAXIMUM WARNING / ERROR *)
			IF IN_EG.rP_Act_Norm > 0.3 THEN
				(* Leistung >  30% Nennleistung *)
				bErrCBTemp_Hi[iCntCB]		:= rT_CBearing[iCntCB] > Para.rT_CBearing_Hi;
				bErrCBTemp_HiHi[iCntCB] 	:= rT_CBearing[iCntCB] > Para.rT_CBearing_HiHi;
			ELSE
				(* Leistung <= 30% Nennleistung -->   offset *)
				IF bAdd_CBearing_Hi_Offset	THEN
					(* Oil temperature > 65°C  --> + offset *)
					bErrCBTemp_Hi[iCntCB]	:= rT_CBearing[iCntCB] > Para.rT_CBearing_Hi   + Para.rT_CBearing_Hi_Offset;
					bErrCBTemp_HiHi[iCntCB]	:= rT_CBearing[iCntCB] > Para.rT_CBearing_HiHi + Para.rT_CBearing_Hi_Offset;
				ELSE
					(* Oil temperature < 65°C  --> - offset *)
					bErrCBTemp_Hi[iCntCB]	:= rT_CBearing[iCntCB] > Para.rT_CBearing_Hi   - Para.rT_CBearing_Hi_Offset;
					bErrCBTemp_HiHi[iCntCB]	:= rT_CBearing[iCntCB] > Para.rT_CBearing_HiHi - Para.rT_CBearing_Hi_Offset;
				END_IF
			END_IF


			(* MEDIAN DEVIATION *)
			bErrCBTempMDev_Lo[iCntCB]		:= (rT_CBearing[iCntCB] < xMEDIAN_Temp.median - Para.rT_CBearing_MDev_HiHi) AND
									 		   (rT_CBearing[iCntCB] > 5);

			bErrCBTempMDev_HiHi[iCntCB]		:= (rT_CBearing[iCntCB] > xMEDIAN_Temp.median + Para.rT_CBearing_MDev_HiHi) AND
									 		   (rT_CBearing[iCntCB] > 5);


			(* SIGNAL STRENGTH ERROR *)
			bErrCBTempSig_Lo[iCntCB] 		:= MM2VIS.iPc_T_CBearing_Sig[iCntCB] < Para.iPc_T_CBearing_Sig_Lo;
		END_IF
	END_FOR



	(********************************************************************************************************************************)
	(************************              				 AMM sequencer	 		             	           **************************)
	(********************************************************************************************************************************)
	xTON_SecondTick(IN := NOT xTON_SecondTick.Q, 					PT:= T#800ms);					(* 800ms + 2x cycle time = 1 sec.*)
	xTON_ReleaseMon(IN := IN_EG.rN_EngAct > 400, 					PT:= T#60s);					(* monitoring delay *)
	xTON_ReleaseMon1(IN:= IN_EG.rN_EngAct >= Para.rN_EngNom * 0.95, PT:= T#60s);					(* monitoring delay *)

	(* ERROR   conrod bearing temperature measuring signal failure *)
	xAmmSeq_TempMs.Enable				:= NOT IN_EG.tAB2EG.bResetWarning; 
	xAmmSeq_TempMs.ClockPulse			:= xTON_SecondTick.Q; 
	xAmmSeq_TempMs.NrOfBits				:= 25; 
	xAmmSeq_TempMs.BitArray				:= ADR(bErrCBTemp_Ms);
	xAmmSeq_TempMs();

	bAMM_T_CBearing_Ms					:= xAmmSeq_TempMs.Alarm1;															(* W2790 *)
	bOpM_T_CBearing_Ms					:= xAmmSeq_TempMs.Alarm2;															(* B2806 *)
	iNum_T_CBearing_Ms  				:= xAmmSeq_TempMs.ErrorNr;

	MM2VIS.iOpM_Pc_T_CBearing_Sig		:= MM2VIS.iPc_T_CBearing_Sig[iNum_T_CBearing_Ms]; 	(* signal strength of tripped cylinder *)


	(* WARNING conrod bearing temperature maximum  *)
	xAmmSeq_TempHi.Enable				:= NOT IN_EG.tAB2EG.bResetWarning AND bOMSS_MAT; 
	xAmmSeq_TempHi.ClockPulse			:= xTON_SecondTick.Q; 
	xAmmSeq_TempHi.NrOfBits				:= 25; 
	xAmmSeq_TempHi.BitArray				:= ADR(bErrCBTemp_Hi);
	xAmmSeq_TempHi();
	
	bAMM_T_CBearing_Hi					:= xAmmSeq_TempHi.Alarm1 	OR IN_EG.tT_CBearing_Hi.Di;								(* W2544 *)
	bOpM_T_CBearing_Hi					:= xAmmSeq_TempHi.Alarm2;															(* B2807 *)
	iNum_T_CBearing_Hi  				:= xAmmSeq_TempHi.ErrorNr;

	
	(* ERROR   conrod bearing temperature maximum  *)
	xAmmSeq_TempHiHi.Enable				:= NOT IN_EG.tAB2EG.bResetTrip AND bOMSS_MAT;  
	xAmmSeq_TempHiHi.ClockPulse			:= xTON_SecondTick.Q; 
	xAmmSeq_TempHiHi.NrOfBits			:= 25; 
	xAmmSeq_TempHiHi.BitArray			:= ADR(bErrCBTemp_HiHi);
	xAmmSeq_TempHiHi();

	bAMM_T_CBearing_HiHi				:= xAmmSeq_TempHiHi.Alarm1	OR IN_EG.tT_CBearing_HiHi.Di;							(* A2230 *)


	(* ERROR   conrod bearing temperature - negative MEDIAN deviation maximum  *)
	xAmmSeq_TempMDevLo.Enable			:= NOT IN_EG.tAB2EG.bResetWarning AND xTON_ReleaseMon.Q; 
	xAmmSeq_TempMDevLo.ClockPulse		:= xTON_SecondTick.Q; 
	xAmmSeq_TempMDevLo.NrOfBits			:= 25;	
	xAmmSeq_TempMDevLo.BitArray			:= ADR(bErrCBTempMDev_Lo);
	xAmmSeq_TempMDevLo();	

	bAMM_T_CBearing_MDev_Lo				:= xAmmSeq_TempMDevLo.Alarm1;														(* W9219 *)
	bOpM_T_CBearing_MDev_Lo				:= xAmmSeq_TempMDevLo.Alarm2;														(* B2959 *)
	iNum_T_CBearing_MDev_Lo				:= xAmmSeq_TempMDevLo.ErrorNr;


	(* ERROR   conrod bearing temperature - positive MEDIAN deviation maximum  *)
	xAmmSeq_TempMDevHiHi.Enable			:= NOT (IN_EG.tAB2EG.bResetTrip OR (IN_EG.tAB2EG.bResetWarning AND bMsg2286_Test)) AND 
										   xTON_ReleaseMon.Q; 
	xAmmSeq_TempMDevHiHi.ClockPulse		:= xTON_SecondTick.Q; 
	xAmmSeq_TempMDevHiHi.NrOfBits		:= 25;	
	xAmmSeq_TempMDevHiHi.BitArray		:= ADR(bErrCBTempMDev_HiHi);
	xAmmSeq_TempMDevHiHi();	
	
	bAMM_T_CBearing_MDev_HiHi			:= xAmmSeq_TempMDevHiHi.Alarm1;														(* A2286 *)
	bOpM_T_CBearing_MDev_HiHi			:= xAmmSeq_TempMDevHiHi.Alarm2;														(* B2905 *)
	iNum_T_CBearing_MDev_HiHi			:= xAmmSeq_TempMDevHiHi.ErrorNr;


	(* ERROR   conrod bearing signal intensity minimum  *)
	xAmmSeq_TempSigLo.Enable			:= NOT IN_EG.tAB2EG.bResetWarning AND xTON_ReleaseMon1.Q AND iSt_ReadStrength = 0; 
	xAmmSeq_TempSigLo.ClockPulse		:= xTON_SecondTick.Q; 
	xAmmSeq_TempSigLo.NrOfBits			:= 25;	
	xAmmSeq_TempSigLo.BitArray			:= ADR(bErrCBTempSig_Lo);
	xAmmSeq_TempSigLo();	
	
	bAMM_T_CBearing_Sig_Lo				:= xAmmSeq_TempSigLo.Alarm1;														(* W3559 *)
	bOpM_T_CBearing_Sig_Lo				:= xAmmSeq_TempSigLo.Alarm2;														(* B2822 *)
	iNum_T_CBearing_Sig_Lo  			:= xAmmSeq_TempSigLo.ErrorNr;



	(********************************************************************************************************************************)
	(************************              						VISU	 	             	   	        	*************************)
	(********************************************************************************************************************************)
	IF iCntCB_MsOk > 0 THEN
		MM2VIS.rT_CBearing_Min			:= rT_CBearing_Min;
		MM2VIS.rT_CBearing_Max			:= rT_CBearing_Max;
		MM2VIS.rT_CBearing_Avg			:= rT_CBearing_Sum / INT_TO_REAL(iCntCB_MsOk);
	ELSE
		MM2VIS.rT_CBearing_Min			:= 0;
		MM2VIS.rT_CBearing_Max			:= 0;
		MM2VIS.rT_CBearing_Min			:= 0;
	END_IF

	IF xEngType.NumberOfCylinder > 0 THEN
		MM2VIS.iPc_T_CBearing_Sig_Min	:= iPc_T_CBearing_Sig_Min;
		MM2VIS.iPc_T_CBearing_Sig_Max	:= iPc_T_CBearing_Sig_Max;
		MM2VIS.iPc_T_CBearing_Sig_Avg	:= iPc_T_CBearing_Sig_Sum  / USINT_TO_INT(xEngType.NumberOfCylinder);

		MM2VIS.iPc_T_CBearing_Gain_Min	:= iPc_T_CBearing_Gain_Min;
		MM2VIS.iPc_T_CBearing_Gain_Max	:= iPc_T_CBearing_Gain_Max;
		MM2VIS.iPc_T_CBearing_Gain_Avg	:= iPc_T_CBearing_Gain_Sum / USINT_TO_INT(xEngType.NumberOfCylinder);
	ELSE
		MM2VIS.iPc_T_CBearing_Sig_Min	:= 0;
		MM2VIS.iPc_T_CBearing_Sig_Max	:= 0;
		MM2VIS.iPc_T_CBearing_Sig_Avg	:= 0;
		MM2VIS.iPc_T_CBearing_Gain_Min	:= 0;
		MM2VIS.iPc_T_CBearing_Gain_Max	:= 0;
		MM2VIS.iPc_T_CBearing_Gain_Avg	:= 0;
	END_IF


	(* bearing position (number) for operating message *)
	MM2VIS.iNum_T_CBearing_MsMs			:= iNum_T_CBearing_Ms;
	MM2VIS.iNum_T_CBearing_Hi			:= iNum_T_CBearing_Hi;
	MM2VIS.iNum_T_CBearing_Sig_Lo		:= iNum_T_CBearing_Sig_Lo;
	MM2VIS.iNum_T_CBearing_MDev_Lo		:= iNum_T_CBearing_MDev_Lo;
	MM2VIS.iNum_T_CBearing_MDev_HiHi	:= iNum_T_CBearing_MDev_HiHi;
END_PROGRAM
