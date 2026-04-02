(*******************************************************************************
VibMonEG: Vigration monitoring engine / generator (init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021     

- monitoring of vibration values incl. frequency bands
- determine max velocity and frequencay at maximum

Customized modifications: -
------------------------

History:
-------
V4.11.0	25-05-2021	Weitzer, 	generated
V4.11.1	04-02-2022	Schmid,		automatic PLC address detection
V4.11.2	20-01-2026	Bacci,		customized for DP29

Instructions FOR use:
--------------------
Sensor 1: Generator horizontal
Sensor 2: Generator vetical
Sensor 3: Engine horizontal
Sensor 4: Engine vetical

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT

//	(*========= DETERMINE POSITION OF X20CM4810 MODULE ==========*)
//	(* ********************************************************* *)
//	(*	reset variables											 *)
//	(* ********************************************************* *)		
//	memset(ADR(sLabelInfo),	 	0, SIZEOF(sLabelInfo));
//
//	(* ********************************************************* *)
//	(*	get information about configured modules				 *)
//	(* ********************************************************* *)
//	xDiagCreateInfo_CM4810.enable	:= TRUE;
//	xDiagCreateInfo_CM4810.infoKind	:= asdiagCONFIGURED;
//	xDiagCreateInfo_CM4810();
//	
//	IF (xDiagCreateInfo_CM4810.status = 0) THEN
//		iIdent 		:= xDiagCreateInfo_CM4810.ident;
//		iNrEntries	:= xDiagCreateInfo_CM4810.nrEntries;
//	END_IF;
//
//	(* ********************************************************* *)
//	(*	get module type of configured modules in Physical		 *)
//	(* ********************************************************* *)		
//	FOR iIndex := 0 TO iNrEntries - 1 DO
//		xDiagGetStrInfo_CM4810.enable		:= TRUE;
//		xDiagGetStrInfo_CM4810.ident		:= iIdent;
//		xDiagGetStrInfo_CM4810.index		:= iIndex;
//		xDiagGetStrInfo_CM4810.infoCode		:= asdiagCONFIG_MODULE;
//		xDiagGetStrInfo_CM4810.pBuffer		:= ADR(sLabelInfo);
//		xDiagGetStrInfo_CM4810.bufferLen	:= SIZEOF(sLabelInfo) - 1;
//		xDiagGetStrInfo_CM4810();
//		
//		IF (xDiagGetStrInfo_CM4810.status = 0) THEN
//		(* ********************************************************* *)
//		(*	get path of X20CM4810 module							 *)
//		(* ********************************************************* *)
//			IF FIND(sLabelInfo, 'X20CM4810') <> 0 THEN
//				xDiagGetStrInfo_CM4810.infoCode		:= asdiagPATH;
//				xDiagGetStrInfo_CM4810.pBuffer		:= ADR(sAddrInfo);
//				xDiagGetStrInfo_CM4810.bufferLen	:= SIZEOF(sAddrInfo) - 1;
//				xDiagGetStrInfo_CM4810();
//				
//				IF (xDiagGetStrInfo_CM4810.status = 0) THEN
//					sCM4810Addr	:=	sAddrInfo;
//				END_IF;
//			END_IF;
//		END_IF;
//	END_FOR;
//	
//	(* ********************************************************* *)
//	(*	free ressources of AsIODiag								 *)
//	(* ********************************************************* *)
//	xDiagDisposeInfo_CM4810.enable := TRUE;	
//	xDiagDisposeInfo_CM4810.ident  := iIdent;
//	xDiagDisposeInfo_CM4810();
//	(*===========================================================*)

//  Prevent compiler warnings	
	xDiagCreateInfo_CM4810.enable := FALSE;
	xDiagGetStrInfo_CM4810.enable := FALSE;
	xDiagDisposeInfo_CM4810.enable := FALSE;
	sLabelInfo;
	sAddrInfo;
	iIndex;
	iIdent;
	iNrEntries;
		
	//  PLC address of 1st X20CM4810 vibration module
	sCM4810Addr := 'IF3.ST33.IF1.ST2';
	
	(* init setting for CM4810 FUB *)
	xCM4810.paramMain.pModulePath			  := ADR(sCM4810Addr); 								(* set path to module *)
	
	xCM4810.enable							  := TRUE; 											(* enable FUB *)
	xCM4810.paramBufferUpload.nrArrayElements := SIZEOF(rData_x_Axis)/SIZEOF(rData_x_Axis[0]);	(* the length of the rData_x_Axis and rData_y_Axis arrays must be the same *)
	xCM4810.paramBufferUpload.pArrayXaxis	  := ADR(rData_x_Axis);								(* load buffer address x axis array *)
	xCM4810.paramBufferUpload.pArrayYaxis	  := ADR(rData_y_Axis);								(* load buffer address y axis array *)
	
	xCM4810.paramBufferUpload.moduleBuffer:= 66;    (* define module buffer for upload *)
	//moduleBuffer  Buffer description                        Signal source             Channel number   Number of values   y-axis unit    x-axis unit 
	//    9         Buffered time signal (amplitude)          Raw acceleration signal      1                8192                [mg]       [seconds] 
	//   11         Buffered time signal (amplitude)          Raw acceleration signal      2                8192                [mg]       [seconds] 
	//   13         Buffered time signal (amplitude)          Raw acceleration signal      3                8192                [mg]       [seconds] 
	//   15         Buffered time signal (amplitude)          Raw acceleration signal      4                8192                [mg]       [seconds] 
	//   25         Buffered time signal (amplitude)          Envelope monitoring          1                8192                [mg]       [seconds] 
	//   27         Buffered time signal (amplitude)          Envelope monitoring          2                8192                [mg]       [seconds] 
	//   29         Buffered time signal (amplitude)          Envelope monitoring          3                8192                [mg]       [seconds] 
	//   31         Buffered time signal (amplitude)          Envelope monitoring          4                8192                [mg]       [seconds] 
	//   66         Spectrum buffered frequency (amplitude)   Raw velocity signal          1                4096                [mm/s]       [Hz] 
	//   67         Spectrum buffered frequency (amplitude)   Raw acceleration signal      1                4096                [mg]         [Hz] 
	//   70         Spectrum buffered frequency (amplitude)   Raw velocity signal          2                4096                [mm/s]       [Hz] 
	//   71         Spectrum buffered frequency (amplitude)   Raw acceleration signal      2                4096                [mg]         [Hz] 
	//   74         Spectrum buffered frequency (amplitude)   Raw velocity signal          3                4096                [mm/s]       [Hz] 
	//   75         Spectrum buffered frequency (amplitude)   Raw acceleration signal      3                4096                [mg]         [Hz] 
	//   78         Spectrum buffered frequency (amplitude)   Raw velocity signal          4                4096                [mm/s]       [Hz] 
	//   79         Spectrum buffered frequency (amplitude)   Raw acceleration signal      4                4096                [mg]         [Hz] 
	//   82         Spectrum buffered frequency (amplitude)   Envelope signal speed        1                4096                [mm/s]       [Hz] 
	//   83         Spectrum buffered frequency (amplitude)   Envelope monitoring          1                4096                [mg]         [Hz] 
	//   86         Spectrum buffered frequency (amplitude)   Envelope signal speed        2                4096                [mm/s]       [Hz] 
	//   87         Spectrum buffered frequency (amplitude)   Envelope monitoring          2                4096                [mg]         [Hz] 
	//   90         Spectrum buffered frequency (amplitude)   Envelope signal speed        3                4096                [mm/s]       [Hz] 
	//   91         Spectrum buffered frequency (amplitude)   Envelope monitoring          3                4096                [mg]         [Hz] 
	//   94         Spectrum buffered frequency (amplitude)   Envelope signal speed        4                4096                [mm/s]       [Hz] 
	//   95         Spectrum buffered frequency (amplitude)   Envelope monitoring          4                4096                [mg]         [Hz] 
	
	(* set sensor sensitivity *)
	rSensitivitySensor[1] := 100.0; (*mV/g*)
	rSensitivitySensor[2] := 100.0; (*mV/g*)
	rSensitivitySensor[3] := 100.0; (*mV/g*)
	rSensitivitySensor[4] := 100.0; (*mV/g*)

	(* Enable application of sensitivity on buffer *)
	xCM4810.paramMain.sensitivitySensor01:=rSensitivitySensor[1];   
	xCM4810.paramMain.sensitivitySensor02:=rSensitivitySensor[2];
	xCM4810.paramMain.sensitivitySensor03:=rSensitivitySensor[3];
	xCM4810.paramMain.sensitivitySensor04:=rSensitivitySensor[4];

	(* initialize values *)	
	tiCM4810_ReadBuffer := T#1m;
	iNum_VibSens		:= 1;
	
END_PROGRAM