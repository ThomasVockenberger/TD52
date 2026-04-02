(*******************************************************************************
Msg_EG	 			 alarms generation MM_EngineGeneral

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2025

Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	18.03.2013	Tinello		new
				24.05.2013	lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
				16.01.2014	lettenb.	OUT_EG.bMsg1056 added
V04.00.01.00	10.04.2014	lettenb.	1026 ton_2ANSTAB 60 --> 70s (auslaufzeit 620 > 60s, JS248_navigat_generat.TD125)	
V04.00.02.00	30.07.2014	Tinello		3368 added		
V04.02.00.00	28.07.2015	Plattner	3396 added		
V04.03.00.00	30.11.2015	Tinello		3559, 2822 added; bugfix 1026	
V04.04.00.00	06.10.2016	Tinello		2790, 2904 and 2905 added; A3378 changed to W2794
				27.10.2016	Weitzer		add A2300 idle friction too high
				31.10.2016	Tinello		add B2190 - B2200 emergency stop push button identification
				11.01.2017	Tinello		allowed slow-down time J920 - changed from 140s to 200s
V04.05.00.00	04.01.2017	Tinello		2230 Änderungsgeschwindigkeit entfernt
										2909 hinzu
				12.10.2017	Weitzer		increase op message 2909 active time from 100ms to 1 s for HMI
V04.05.01.00	19.03.2018	Tinello		Bearing Specification (f)
V04.05.03.00	12.09.2018	Tinello		Bugfix: Alarm bypass, bu
V04.07.00.00	30.04.2019	Tinello		Neuer Not Halt Taster TCMSCAV / restore slow-down time error after cold start of CPU
V04.10.00.00	28.01.2021	Tinello		Bugfix: Engine running without demand in island operation / WinMOD simulation included
V04.11.00.00	14.01.2022	Schmidt		Added messages for PU scuffing detection (A2362, OM2981)
V04.12.00.00	19.12.2022	Perktold	added comments for sr-code (EN 13849-1 / 4.6.3) for A1026
				26.01.2023	Tinello		Allowed slow-down time for type 6 engines changed from 80s to 100s (#802)
V04.14.00.00	31.01.2025	Perktold	Bugfix A1026 shutdown failure for island mode and grid mode with gas type 0				
				26.02.2025	Tinello		Added safety related alarms
V04.25.00.00	24.09.2025	Tinello		Added safety related alarms

Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	


3)  expand INIT

3)	include datapoint into OPC configuration for vis

			
Outstandings:
------------
(****************************************************************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	OUT_EG.tEG2AB.bGnlTrip1		:= FALSE;
	OUT_EG.tEG2AB.bGnlTrip2		:= FALSE;
	OUT_EG.tEG2AB.bGnlTrip3		:= FALSE;
	OUT_EG.tEG2AB.bGnlWarning	:= FALSE;
	OUT_EG.tEG2AB.bTriptype1	:= FALSE;
	OUT_EG.tEG2AB.bTriptype2	:= FALSE;
	OUT_EG.tEG2AB.bTriptype3	:= FALSE;


	(*-----------------------------------------------------------------------*)

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)

	(* A1026 shutdown failure *)
		(* generator circuit breaker still closed *)
		xTON_1026_A(IN := NOT IN_EG.tRel_Sync_Load.Do AND IN_EG.tGCB_On.Di, PT := T#2s );

		(* slow-down time exceeded *)
		IF 	  xEngType.Type9 THEN xTON_1026_B.PT := T#200s; 				(* allowed slow-down time - type series 9 	 *)
		ELSIF xEngType.Type6 THEN xTON_1026_B.PT := T#100s; 				(* allowed slow-down time - type series 6 	 *)
						  	 ELSE xTON_1026_B.PT := T#60s; 	END_IF			(* allowed slow-down time - other enginetype *)
		
		xTON_1026_B(IN := NOT IN_EG.tEng_Run.Do AND bStartSpd);

		(* engine running without demand *)
		IF xOpMode.Island THEN
			rP_Ramp_DecGrad	:= LIMIT(0.00001, Para.rP_Island_Split_DecGrad_Norm[1], 		  1);		(* avoid division by 0 *)
		ELSE
			IF (IN_EG.iIdx_Gtyp_Dem = 0) THEN
				rP_Ramp_DecGrad	:= LIMIT(0.00001, IN_EG.rP_Ramp_DecGrad_Norm_Gtyp0, 1);					(* avoid division by 0 *)
			ELSE
				rP_Ramp_DecGrad	:= LIMIT(0.00001, Para.rP_Ramp_DecGrad_Norm[IN_EG.iIdx_Gtyp_Dem], 1);	(* avoid division by 0 *)
			END_IF
		END_IF
	
		tiRunOut		:= REAL_TO_TIME((1 / rP_Ramp_DecGrad) * 1000) + 							(* power ramp decrease time *)
					 	   xTON_1026_B.PT + 														(* slow-down time *)
					   	   T#60s;																	(* aftercooling time *)

		xTON_1026_C(IN := NOT IN_EG.bEng_Dem_Man AND NOT IN_EG.bEng_Dem_Aut AND (bStartSpd OR NOT bP_Lo_Trig), 
					PT := MIN(T#15m, tiRunOut) );

	xMsg1026.Enable	   		:= bRelModul_ParaSetupOk;
	xMsg1026.Set 	   		:= xTON_1026_A.Q OR xTON_1026_B.Q OR xTON_1026_C.Q;
	xMsg1026.PT		  	 	:= T#0s;
	xMsg1026.Prio 	  	 	:= 2;
	xMsg1026.RiskClass		:= 10;
	xMsg1026.Reset	   		:= FALSE;
	xMsg1026();
	MM2VIS.bMsg1026 		:= xMsg1026.Q;
	OUT_EG.bMsg1026			:= xMsg1026.Q;
	OUT_EG.bMsg1026_Test	:= xMsg1026.Test;        
	
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)	
	
	(* A1031 safety loop - emergency stop push button *)
	xMsg1031.Enable	  	 	:= bRelModul_ParaSetupOk;
	xMsg1031.Set 	  	 	:= NOT IN_EG.tSafetyLoop_EmStop.Di;
	xMsg1031.PT		  	 	:= T#0s;
	xMsg1031.Prio 	  	 	:= 2;
	xMsg1031.RiskClass	 	:= 4;
	xMsg1031.Reset	   		:= FALSE;
	xMsg1031();
	MM2VIS.bMsg1031 		:= xMsg1031.Q;
	OUT_EG.bMsg1031			:= xMsg1031.Q;

	
	
	(* A1056 safety loop - engine *)
	xMsg1056.Enable	   		:= bRelModul_ParaSetupOk;
	xMsg1056.Set 	   		:= bMsg1056_Set;								(* alarm delayed for one cycle *)
	xMsg1056.PT		   		:= T#0ms;									
	xMsg1056.Prio 	   		:= 2;
	xMsg1056.RiskClass 		:= 10;											(* Nicht fernquittierbar *)
	xMsg1056.Reset	   		:= EDGENEG(IN_EG.tMonitoringOn.Do);				(* acknowledgement *)
	xMsg1056();
	MM2VIS.bMsg1056 		:= xMsg1056.Q;
	OUT_EG.bMsg1056			:= xMsg1056.Q;

	bMsg1056_Set			:= NOT IN_EG.tSafetyLoop_Eng.Di AND NOT IN_EG.bDeflagrationPrct;	(* alarm set delay *)
	
	
	
	(* W1168 group message because of maintenance counter *)
	xMsg1168.Enable	   		:= bRelModul_ParaSetupOk;
	xMsg1168.Set 	   		:= IN_EG.bReqMaintenance;
	xMsg1168.PT		   		:= T#0s;
	xMsg1168.Prio 	   		:= 4;
	xMsg1168.RiskClass 		:= 4;	
	xMsg1168.Reset	   		:= FALSE;
	xMsg1168();
	MM2VIS.bMsg1168 		:= xMsg1168.Q;


	(* A2227 measuring signal failure main bearing temperature *)		(* --> NOT USED *)
	xMsg2227.Enable	   		:= FALSE; 
	xMsg2227.Set 	  		:= FALSE; 
	xMsg2227.PT	       		:= T#0s;
	xMsg2227.Prio 	   		:= 2;
	xMsg2227.RiskClass 		:= 4;
	xMsg2227.Reset 	   		:= FALSE;
	xMsg2227();
	MM2VIS.bMsg2227    		:= xMsg2227.Q;


	(* A2228 main bearing temperature high *)
	xMsg2228.Enable	   		:= TRUE; 
	xMsg2228.Set 	  		:= bAMM_T_MBearing_HiHi; 
	xMsg2228.PT	       		:= T#0s;
	xMsg2228.Prio 	   		:= 1;
	xMsg2228.RiskClass 		:= 4;
	xMsg2228.Reset 	   		:= FALSE;
	xMsg2228();
	MM2VIS.bMsg2228    		:= xMsg2228.Q;


	(* A2229 conrod bearing monitoring CAN communication failure *)
	xMsg2229.Enable	   		:= NOT IN_EG.bSimWinMOD_Active;
	xMsg2229.Set 	  		:= bAMM_T_CBearing_CAN; 
	xMsg2229.PT	       		:= T#0s;
	xMsg2229.Prio 	   		:= 2;
	xMsg2229.RiskClass 		:= 4;
	xMsg2229.Reset 	   		:= FALSE;
	xMsg2229();
	MM2VIS.bMsg2229    		:= xMsg2229.Q;


	(* A2230 conrod bearing temperature high *)
	xMsg2230.Enable	   		:= TRUE; 
	xMsg2230.Set 	  		:= bAMM_T_CBearing_HiHi; 
	xMsg2230.PT	       		:= T#0s;
	xMsg2230.Prio 	   		:= 1;
	xMsg2230.RiskClass 		:= 4;
	xMsg2230.Reset 	   		:= FALSE;
	xMsg2230();
	MM2VIS.bMsg2230    		:= xMsg2230.Q;


	(* A2232  measuring signal failure barometric pressure *)		(* --> NOT USED *)
	xMsg2232.Enable	   		:= FALSE; 
	xMsg2232.Set 	  		:= FALSE; 
	xMsg2232.PT	       		:= T#0s;
	xMsg2232.Prio 	   		:= 1;
	xMsg2232.RiskClass 		:= 4;
	xMsg2232.Reset 	   		:= FALSE;
	xMsg2232();
	MM2VIS.bMsg2232    		:= xMsg2232.Q;


	(* A2270 measuring signal failure conrod bearing temperature *)		(* --> NOT USED *)
	xMsg2270.Enable	   		:= FALSE; 
	xMsg2270.Set 	  		:= FALSE; 
	xMsg2270.PT	       		:= T#0s;
	xMsg2270.Prio 	   		:= 2;
	xMsg2270.RiskClass 		:= 4;
	xMsg2270.Reset 	   		:= FALSE;
	xMsg2270();
	MM2VIS.bMsg2270    		:= xMsg2270.Q;


	(* A2285 main bearing temperature - positive deviation from average value *)
	xMsg2285.Enable	   		:= TRUE; 
	xMsg2285.Set 	  		:= bAMM_T_MBearing_MDev_HiHi; 
	xMsg2285.PT	       		:= T#0s;
	xMsg2285.Prio 	   		:= 1;
	xMsg2285.RiskClass 		:= 4;
	xMsg2285.Reset 	   		:= FALSE;
	xMsg2285();
	MM2VIS.bMsg2285    		:= xMsg2285.Q;
	bMsg2285_Test	 		:= xMsg2285.Test;	(* active during the alarm bypass *)


	(* A2286 conrod bearing temperature - positive deviation from average value *)
	xMsg2286.Enable	   		:= TRUE; 
	xMsg2286.Set 	  		:= bAMM_T_CBearing_MDev_HiHi; 
	xMsg2286.PT	       		:= T#0s;
	xMsg2286.Prio 	   		:= 1;
	xMsg2286.RiskClass 		:= 4;
	xMsg2286.Reset 	   		:= FALSE;
	xMsg2286();
	MM2VIS.bMsg2286    		:= xMsg2286.Q;
	bMsg2286_Test	 		:= xMsg2286.Test;	(* active during the alarm bypass *)


	(* A2300 idle friction too high *)
	xMsg2300.Enable	   		:= TRUE; 
	xMsg2300.Set 	  		:= bAMM_IdleFriction_HiHi; 
	xMsg2300.PT	       		:= T#0s;
	xMsg2300.Prio 	   		:= 1;
	xMsg2300.RiskClass 		:= 4;
	xMsg2300.Reset 	   		:= FALSE;
	xMsg2300();
	MM2VIS.bMsg2300    		:= xMsg2300.Q;
	
	(* A2362 PU scuffing detection *)
	xMsg2362.Enable	   		:= Para.bPUscf_Ena; 
	xMsg2362.Set 	  		:= bAMM_PUscuff; 
	xMsg2362.PT	       		:= T#0s;
	xMsg2362.Prio 	   		:= 3;
	xMsg2362.RiskClass 		:= 4;
	xMsg2362.Reset 	   		:= FALSE;
	xMsg2362();
	MM2VIS.bMsg2362    		:= xMsg2362.Q;


	(* A2383 SAFETY - Exhaust gas backpressure high *)						
	xMsg2383.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2383.Set	  		:= NOT bAMM_2383;			
	xMsg2383.PT	       		:= T#0s;			
	xMsg2383.Prio	   		:= 3;			
	xMsg2383.RiskClass		:= 4;				
	xMsg2383.Reset	   		:= FALSE;			
	xMsg2383();						
	MM2VIS.bMsg2383			:= xMsg2383.Q;			
							
	(* A2384 SAFETY - Speed deviation to ignition speed *)						
	xMsg2384.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2384.Set	  		:= NOT bAMM_2384;			
	xMsg2384.PT	       		:= T#0s;			
	xMsg2384.Prio	   		:= 3;			
	xMsg2384.RiskClass		:= 4;				
	xMsg2384.Reset	   		:= FALSE;			
	xMsg2384();						
	MM2VIS.bMsg2384			:= xMsg2384.Q;			
							
	(* A2385 SAFETY - Ignition system failure *)						
	xMsg2385.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2385.Set	  		:= NOT bAMM_2385;			
	xMsg2385.PT	       		:= T#0s;			
	xMsg2385.Prio	   		:= 3;			
	xMsg2385.RiskClass		:= 4;				
	xMsg2385.Reset	   		:= FALSE;			
	xMsg2385();						
	MM2VIS.bMsg2385			:= xMsg2385.Q;			

	(* A2386 SAFETY - Oil pressure minimum *)						
	xMsg2386.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2386.Set	  		:= NOT bAMM_2386;			
	xMsg2386.PT	       		:= T#0s;			
	xMsg2386.Prio	   		:= 3;			
	xMsg2386.RiskClass		:= 4;				
	xMsg2386.Reset	   		:= FALSE;			
	xMsg2386();						
	MM2VIS.bMsg2386			:= xMsg2386.Q;			
							
	(* A2387 SAFETY - Oil pressure measuring signal failure *)						
	xMsg2387.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2387.Set	  		:= NOT bAMM_2387;			
	xMsg2387.PT	       		:= T#0s;			
	xMsg2387.Prio	   		:= 3;			
	xMsg2387.RiskClass		:= 4;				
	xMsg2387.Reset	   		:= FALSE;			
	xMsg2387();						
	MM2VIS.bMsg2387			:= xMsg2387.Q;			
							
	(* A2388 SAFETY - Oil pressure implausible value *)						
	xMsg2388.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2388.Set	  		:= NOT bAMM_2388;			
	xMsg2388.PT	       		:= T#0s;			
	xMsg2388.Prio	   		:= 3;			
	xMsg2388.RiskClass		:= 4;				
	xMsg2388.Reset	   		:= FALSE;			
	xMsg2388();						
	MM2VIS.bMsg2388			:= xMsg2388.Q;			
	
	(* A2389 SAFETY - Oil pressure deviation between the sensors *)						
	xMsg2389.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2389.Set	  		:= NOT bAMM_2389;			
	xMsg2389.PT	       		:= T#0s;			
	xMsg2389.Prio	   		:= 3;			
	xMsg2389.RiskClass		:= 4;				
	xMsg2389.Reset	   		:= FALSE;			
	xMsg2389();						
	MM2VIS.bMsg2389			:= xMsg2389.Q;			
							
	(* A2390 SAFETY - Oil pressure maximum (sensor drift) *)						
	xMsg2390.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2390.Set	  		:= NOT bAMM_2390;			
	xMsg2390.PT	       		:= T#0s;			
	xMsg2390.Prio	   		:= 3;			
	xMsg2390.RiskClass		:= 4;				
	xMsg2390.Reset	   		:= FALSE;			
	xMsg2390();						
	MM2VIS.bMsg2390			:= xMsg2390.Q;			
							
	(* A2391 SAFETY - Oil pressure sensor value frozen *)						
	xMsg2391.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2391.Set	  		:= NOT bAMM_2391;			
	xMsg2391.PT	       		:= T#0s;			
	xMsg2391.Prio	   		:= 3;			
	xMsg2391.RiskClass		:= 4;				
	xMsg2391.Reset	   		:= FALSE;			
	xMsg2391();						
	MM2VIS.bMsg2391			:= xMsg2391.Q;			
	
	(* A2392 SAFETY - Oil pressure after pump maximum *)						
	xMsg2392.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2392.Set	  		:= NOT bAMM_2392;			
	xMsg2392.PT	       		:= T#0s;			
	xMsg2392.Prio	   		:= 3;			
	xMsg2392.RiskClass		:= 4;				
	xMsg2392.Reset	   		:= FALSE;			
	xMsg2392();						
	MM2VIS.bMsg2392			:= xMsg2392.Q;			
							
	(* A2393 SAFETY - Oil pressure after pump measuring signal failure *)						
	xMsg2393.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2393.Set	  		:= NOT bAMM_2393;			
	xMsg2393.PT	       		:= T#0s;			
	xMsg2393.Prio	   		:= 3;			
	xMsg2393.RiskClass		:= 4;				
	xMsg2393.Reset	   		:= FALSE;			
	xMsg2393();						
	MM2VIS.bMsg2393			:= xMsg2393.Q;			
							
	(* A2394 SAFETY - Oil pressure after pump implausible value *)						
	xMsg2394.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2394.Set	  		:= NOT bAMM_2394;			
	xMsg2394.PT	       		:= T#0s;			
	xMsg2394.Prio	   		:= 3;			
	xMsg2394.RiskClass		:= 4;				
	xMsg2394.Reset	   		:= FALSE;			
	xMsg2394();						
	MM2VIS.bMsg2394			:= xMsg2394.Q;			
	
	(* A2395 SAFETY - Oil pressure after pump sensor value frozen *)						
	xMsg2395.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2395.Set	  		:= NOT bAMM_2395;			
	xMsg2395.PT	       		:= T#0s;			
	xMsg2395.Prio	   		:= 3;			
	xMsg2395.RiskClass		:= 4;				
	xMsg2395.Reset	   		:= FALSE;			
	xMsg2395();						
	MM2VIS.bMsg2395			:= xMsg2395.Q;			
							
	(* A2396 SAFETY - Engine cooling water pressure minimum *)						
	xMsg2396.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2396.Set	  		:= NOT bAMM_2396;			
	xMsg2396.PT	       		:= T#0s;			
	xMsg2396.Prio	   		:= 3;			
	xMsg2396.RiskClass		:= 4;				
	xMsg2396.Reset	   		:= FALSE;			
	xMsg2396();						
	MM2VIS.bMsg2396			:= xMsg2396.Q;			
							
	(* A2397 SAFETY - Engine cooling water pressure measuring signal failure *)						
	xMsg2397.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2397.Set	  		:= NOT bAMM_2397;			
	xMsg2397.PT	       		:= T#0s;			
	xMsg2397.Prio	   		:= 3;			
	xMsg2397.RiskClass		:= 4;				
	xMsg2397.Reset	   		:= FALSE;			
	xMsg2397();						
	MM2VIS.bMsg2397			:= xMsg2397.Q;			
	
	(* A2398 SAFETY - Engine cooling water pressure deviation between the sensors *)						
	xMsg2398.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2398.Set	  		:= NOT bAMM_2398;			
	xMsg2398.PT	       		:= T#0s;			
	xMsg2398.Prio	   		:= 3;			
	xMsg2398.RiskClass		:= 4;				
	xMsg2398.Reset	   		:= FALSE;			
	xMsg2398();						
	MM2VIS.bMsg2398			:= xMsg2398.Q;			


	(* W2542 main bearing temperature high *)
	xMsg2542.Enable	   		:= TRUE; 		
	xMsg2542.Set 	   		:= bAMM_T_MBearing_Hi; 
	xMsg2542.PT	       		:= T#0s;
	xMsg2542.Prio 	   		:= 4;
	xMsg2542.RiskClass 		:= 4;
	xMsg2542.Reset 	   		:= FALSE;
	xMsg2542();
	MM2VIS.bMsg2542    		:= xMsg2542.Q;


	(* W2544 Conrod bearing temperature high *)
	xMsg2544.Enable	   		:= TRUE; 		
	xMsg2544.Set 	   		:= bAMM_T_CBearing_Hi; 
	xMsg2544.PT	       		:= T#0s;
	xMsg2544.Prio 	   		:= 4;
	xMsg2544.RiskClass 		:= 4;
	xMsg2544.Reset 	   		:= FALSE;
	xMsg2544();
	MM2VIS.bMsg2544    		:= xMsg2544.Q;


	(* W2552 barometric pressure low *)
	xMsg2552.Enable	   		:= TRUE; 		
	xMsg2552.Set 	   		:= bAMM_Pr_Baro_siteDev_Lo; 
	xMsg2552.PT	       		:= T#2s;
	xMsg2552.Prio 	   		:= 4;
	xMsg2552.RiskClass 		:= 4;
	xMsg2552.Reset 	   		:= FALSE;
	xMsg2552();
	MM2VIS.bMsg2552    		:= xMsg2552.Q;

	
	(* W2553 barometric pressure high *)
	xMsg2553.Enable	   		:= TRUE;		
	xMsg2553.Set 	   		:= bAMM_Pr_Baro_siteDev_Hi; 
	xMsg2553.PT	       		:= T#2s;
	xMsg2553.Prio 	   		:= 4;
	xMsg2553.RiskClass 		:= 4;
	xMsg2553.Reset 	   		:= FALSE;
	xMsg2553();
	MM2VIS.bMsg2553    		:= xMsg2553.Q;


	(* W2561 barometric pressure unequal gas rail pressure - lockout start sequence *)		(* --> NOT USED *)
	xMsg2561.Enable	   		:= FALSE;		
	xMsg2561.Set 	   		:= FALSE;
	xMsg2561.PT	       		:= T#0s;
	xMsg2561.Prio 	   		:= 4;
	xMsg2561.RiskClass 		:= 4;
	xMsg2561.Reset 	   		:= FALSE;
	xMsg2561();
	MM2VIS.bMsg2561    		:= xMsg2561.Q;


	(* W2790 Measuring signal failure conrod bearing temperature *)
	xMsg2790.Enable	   		:= NOT IN_EG.bSimWinMOD_Active;
	xMsg2790.Set 	   		:= bAMM_T_CBearing_Ms;
	xMsg2790.PT	       		:= T#0s;
	xMsg2790.Prio 	   		:= 4;
	xMsg2790.RiskClass 		:= 4;
	xMsg2790.Reset 	   		:= FALSE;
	xMsg2790();
	MM2VIS.bMsg2790    		:= xMsg2790.Q;


	(* W2794 conrod bearing temperature calibration unsuccessful *)
	xMsg2794.Enable	   		:= TRUE;
	xMsg2794.Set 	   		:= bAMM_T_CBearing_Calib;
	xMsg2794.PT		   		:= T#120s;
	xMsg2794.Prio 	   		:= 4;
	xMsg2794.RiskClass 		:= 4;	
	xMsg2794.Reset	   		:= FALSE;
	xMsg2794();
	MM2VIS.bMsg2794 		:= xMsg2794.Q;


	(* A3368 Slow down time too short *)
	xMsg3368.Enable	   		:= TRUE;
	xMsg3368.Set 	   		:= bAMM_SlowDownTime_LoLo OR EDGEPOS(bAMM_SlowDownTime_LoLo_Save);
	xMsg3368.PT		   		:= T#0s;
	xMsg3368.Prio 	   		:= 3;
	xMsg3368.RiskClass 		:= 0;	
	xMsg3368.Reset	   		:= FALSE;
	xMsg3368.LockReset 		:= IN_EG.iPassLevel < iPassLevelReset;
	xMsg3368();
	MM2VIS.bMsg3368 		:= xMsg3368.Q;


	(* A3378 conrod bearing temperature calibration unsuccessful *)		(* --> NOT USED *)
	xMsg3378.Enable	   		:= FALSE;
	xMsg3378.Set 	   		:= FALSE;
	xMsg3378.PT		   		:= T#0s;
	xMsg3378.Prio 	   		:= 3;
	xMsg3378.RiskClass 		:= 0;	
	xMsg3378.Reset	   		:= FALSE;
	xMsg3378();
	MM2VIS.bMsg3378 		:= xMsg3378.Q;

	
	(* A3396 emergency stop with cool down run *)
	xMsg3396.Enable	   		:= TRUE;
	xMsg3396.Set 	   		:= NOT IN_EG.tEmStop_CoolRun.Di;
	xMsg3396.PT	       		:= T#0s;
	xMsg3396.Prio 	   		:= 2;
	xMsg3396.RiskClass 		:= 4;
	xMsg3396.Reset 	   		:= FALSE;
	xMsg3396();
	MM2VIS.bMsg3396    		:= xMsg3396.Q;

	
	(* W3449 Measurement signal failure barometric pressure *)
	xMsg3449.Enable	   		:= TRUE;
	xMsg3449.Set 	   		:= bAMM_Pr_Baro_Ms;
	xMsg3449.PT	       		:= T#2s;
	xMsg3449.Prio 	   		:= 4;
	xMsg3449.RiskClass 		:= 4;
	xMsg3449.Reset 	   		:= FALSE;
	xMsg3449();
	MM2VIS.bMsg3449    		:= xMsg3449.Q;	
	
	(* W3559 conrod bearing signal intensity minimum *)
	xMsg3559.Enable	   		:= NOT IN_EG.bSimWinMOD_Active;
	xMsg3559.Set 	   		:= bAMM_T_CBearing_Sig_Lo; 
	xMsg3559.PT	       		:= T#0s;
	xMsg3559.Prio 	   		:= 4;
	xMsg3559.RiskClass 		:= 4;
	xMsg3559.Reset 	   		:= FALSE;
	xMsg3559();
	MM2VIS.bMsg3559    		:= xMsg3559.Q;

	(* W9217 measuring signal failure main bearing temperature *)
	xMsg9217.Enable	   		:= NOT IN_EG.bSimWinMOD_Active;
	xMsg9217.Set 	  		:= bAMM_T_MBearing_Ms; 
	xMsg9217.PT	       		:= T#0s;
	xMsg9217.Prio 	   		:= 4;
	xMsg9217.RiskClass 		:= 4;
	xMsg9217.Reset 	   		:= FALSE;
	xMsg9217();
	MM2VIS.bMsg9217    		:= xMsg9217.Q;

	(* W9218 Main bearing temperature - negative deviation from average value *)
	xMsg9218.Enable	   		:= TRUE; 
	xMsg9218.Set 	  		:= bAMM_T_MBearing_MDev_Lo;
	xMsg9218.PT	       		:= T#0s;
	xMsg9218.Prio 	   		:= 4;
	xMsg9218.RiskClass 		:= 4;
	xMsg9218.Reset 	   		:= FALSE;
	xMsg9218();
	MM2VIS.bMsg9218    		:= xMsg9218.Q;

	(* W9219 Conrod bearing temperature - negative deviation from average value *)
	xMsg9219.Enable	   		:= TRUE; 
	xMsg9219.Set 	  		:= bAMM_T_CBearing_MDev_Lo; 
	xMsg9219.PT	       		:= T#0s;
	xMsg9219.Prio 	   		:= 4;
	xMsg9219.RiskClass 		:= 4;
	xMsg9219.Reset 	   		:= FALSE;
	xMsg9219();
	MM2VIS.bMsg9219    		:= xMsg9219.Q;

	
	(* A9408 SAFETY - Engine cooling water pressure maximum (sensor drift) *)						
	xMsg9408.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9408.Set	  		:= NOT bAMM_9408;			
	xMsg9408.PT	       		:= T#0s;			
	xMsg9408.Prio	   		:= 3;			
	xMsg9408.RiskClass		:= 4;				
	xMsg9408.Reset	   		:= FALSE;			
	xMsg9408();						
	MM2VIS.bMsg9408			:= xMsg9408.Q;			
							
	(* A9409 SAFETY - Engine cooling water pressure sensor value frozen *)						
	xMsg9409.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9409.Set	  		:= NOT bAMM_9409;			
	xMsg9409.PT	       		:= T#0s;			
	xMsg9409.Prio	   		:= 3;			
	xMsg9409.RiskClass		:= 4;				
	xMsg9409.Reset	   		:= FALSE;			
	xMsg9409();						
	MM2VIS.bMsg9409			:= xMsg9409.Q;			
							
	(* A9410 SAFETY - Engine cooling water pressure after pump maximum *)						
	xMsg9410.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9410.Set	  		:= NOT bAMM_9410;			
	xMsg9410.PT	       		:= T#0s;			
	xMsg9410.Prio	   		:= 3;			
	xMsg9410.RiskClass		:= 4;				
	xMsg9410.Reset	   		:= FALSE;			
	xMsg9410();						
	MM2VIS.bMsg9410			:= xMsg9410.Q;			
	
	(* A9411 SAFETY - Engine cooling water pressure after pump measuring signal failure *)						
	xMsg9411.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9411.Set	  		:= NOT bAMM_9411;			
	xMsg9411.PT	       		:= T#0s;			
	xMsg9411.Prio	   		:= 3;			
	xMsg9411.RiskClass		:= 4;				
	xMsg9411.Reset	   		:= FALSE;			
	xMsg9411();						
	MM2VIS.bMsg9411			:= xMsg9411.Q;			
							
	(* A9412 SAFETY - Engine cooling water pressure after pump sensor value frozen *)						
	xMsg9412.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9412.Set	  		:= NOT bAMM_9412;			
	xMsg9412.PT	       		:= T#0s;			
	xMsg9412.Prio	   		:= 3;			
	xMsg9412.RiskClass		:= 4;				
	xMsg9412.Reset	   		:= FALSE;			
	xMsg9412();						
	MM2VIS.bMsg9412			:= xMsg9412.Q;			
							
	(* A9413 SAFETY - Generator circuit breaker opening failure *)						
	xMsg9413.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9413.Set	  		:= NOT bAMM_9413;			
	xMsg9413.PT	       		:= T#0s;			
	xMsg9413.Prio	   		:= 3;			
	xMsg9413.RiskClass		:= 4;				
	xMsg9413.Reset	   		:= FALSE;			
	xMsg9413();						
	MM2VIS.bMsg9413			:= xMsg9413.Q;			
	
	(* A9414 SAFETY - Generator circuit breaker position feedback error *)						
	xMsg9414.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9414.Set	  		:= NOT bAMM_9414;			
	xMsg9414.PT	       		:= T#0s;			
	xMsg9414.Prio	   		:= 3;			
	xMsg9414.RiskClass		:= 4;				
	xMsg9414.Reset	   		:= FALSE;			
	xMsg9414();						
	MM2VIS.bMsg9414			:= xMsg9414.Q;			
							
	(* A9415 SAFETY - Generator overload/short circuit *)						
	xMsg9415.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9415.Set	  		:= NOT bAMM_9415;			
	xMsg9415.PT	       		:= T#0s;			
	xMsg9415.Prio	   		:= 3;			
	xMsg9415.RiskClass		:= 4;				
	xMsg9415.Reset	   		:= FALSE;			
	xMsg9415();						
	MM2VIS.bMsg9415			:= xMsg9415.Q;			
							
	(* A9416 SAFETY - Generator protection trip *)						
	xMsg9416.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9416.Set	  		:= NOT bAMM_9416;			
	xMsg9416.PT	       		:= T#0s;			
	xMsg9416.Prio	   		:= 3;			
	xMsg9416.RiskClass		:= 4;				
	xMsg9416.Reset	   		:= FALSE;			
	xMsg9416();						
	MM2VIS.bMsg9416			:= xMsg9416.Q;			
	
	(* A9417 SAFETY - Collective fault in room ventilation *)						
	xMsg9417.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9417.Set	  		:= NOT bAMM_9417;			
	xMsg9417.PT	       		:= T#0s;			
	xMsg9417.Prio	   		:= 3;			
	xMsg9417.RiskClass		:= 4;				
	xMsg9417.Reset	   		:= FALSE;			
	xMsg9417();						
	MM2VIS.bMsg9417			:= xMsg9417.Q;			
							
	(* A9418 SAFETY - Emergency stop push button - Module interface panel *)						
	xMsg9418.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9418.Set	  		:= NOT bAMM_9418;			
	xMsg9418.PT	       		:= T#0s;			
	xMsg9418.Prio	   		:= 3;			
	xMsg9418.RiskClass		:= 4;				
	xMsg9418.Reset	   		:= FALSE;			
	xMsg9418();						
	MM2VIS.bMsg9418			:= xMsg9418.Q;			
							
	(* A9419 SAFETY - Emergency stop push button *)						
	xMsg9419.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9419.Set	  		:= NOT bAMM_9419;			
	xMsg9419.PT	       		:= T#0s;			
	xMsg9419.Prio	   		:= 3;			
	xMsg9419.RiskClass		:= 4;				
	xMsg9419.Reset	   		:= FALSE;			
	xMsg9419();						
	MM2VIS.bMsg9419			:= xMsg9419.Q;			
	
	(* A9420 SAFETY - Safety loop 1 tripped - Module control panel *)						
	xMsg9420.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9420.Set	  		:= NOT bAMM_9420;			
	xMsg9420.PT	       		:= T#0s;			
	xMsg9420.Prio	   		:= 3;			
	xMsg9420.RiskClass		:= 4;				
	xMsg9420.Reset	   		:= FALSE;			
	xMsg9420();						
	MM2VIS.bMsg9420			:= xMsg9420.Q;			
							
	(* A9421 SAFETY - Failure gas train 1 *)						
	xMsg9421.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9421.Set	  		:= NOT bAMM_9421;			
	xMsg9421.PT	       		:= T#0s;			
	xMsg9421.Prio	   		:= 3;			
	xMsg9421.RiskClass		:= 4;				
	xMsg9421.Reset	   		:= FALSE;			
	xMsg9421();						
	MM2VIS.bMsg9421			:= xMsg9421.Q;			
							
	(* A9422 SAFETY - Failure gas train 2 *)						
	xMsg9422.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9422.Set	  		:= NOT bAMM_9422;			
	xMsg9422.PT	       		:= T#0s;			
	xMsg9422.Prio	   		:= 3;			
	xMsg9422.RiskClass		:= 4;				
	xMsg9422.Reset	   		:= FALSE;			
	xMsg9422();						
	MM2VIS.bMsg9422			:= xMsg9422.Q;			
	
	(* A9423 SAFETY - Failure gas train 3 *)						
	xMsg9423.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9423.Set	  		:= NOT bAMM_9423;			
	xMsg9423.PT	       		:= T#0s;			
	xMsg9423.Prio	   		:= 3;			
	xMsg9423.RiskClass		:= 4;				
	xMsg9423.Reset	   		:= FALSE;			
	xMsg9423();						
	MM2VIS.bMsg9423			:= xMsg9423.Q;			
							
	(* A9424 SAFETY - Failure gas train 4 *)						
	xMsg9424.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9424.Set	  		:= NOT bAMM_9424;			
	xMsg9424.PT	       		:= T#0s;			
	xMsg9424.Prio	   		:= 3;			
	xMsg9424.RiskClass		:= 4;				
	xMsg9424.Reset	   		:= FALSE;			
	xMsg9424();						
	MM2VIS.bMsg9424			:= xMsg9424.Q;			
							
	(* A9425 SAFETY - Safety functions module interface panel - output not valid *)						
	xMsg9425.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9425.Set	  		:= NOT bAMM_9425;			
	xMsg9425.PT	       		:= T#0s;			
	xMsg9425.Prio	   		:= 3;			
	xMsg9425.RiskClass		:= 4;				
	xMsg9425.Reset	   		:= FALSE;			
	xMsg9425();						
	MM2VIS.bMsg9425			:= xMsg9425.Q;			
							
	(* A9426 SAFETY - Safety functions module control panel - output not valid *)						
	xMsg9426.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9426.Set	  		:= NOT bAMM_9426;			
	xMsg9426.PT	       		:= T#0s;			
	xMsg9426.Prio	   		:= 3;			
	xMsg9426.RiskClass		:= 4;				
	xMsg9426.Reset	   		:= FALSE;			
	xMsg9426();						
	MM2VIS.bMsg9426			:= xMsg9426.Q;			

	(* A9427 SAFETY - Engine type mismatch *)						
	xMsg9427.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9427.Set	  		:= NOT bAMM_9427;			
	xMsg9427.PT	       		:= T#0s;			
	xMsg9427.Prio	   		:= 3;			
	xMsg9427.RiskClass		:= 4;				
	xMsg9427.Reset	   		:= FALSE;			
	xMsg9427();						
	MM2VIS.bMsg9427			:= xMsg9427.Q;			
							
	(* A9428 SAFETY - Room ventilation failure - Plausibility check pending *)						
	xMsg9428.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9428.Set	  		:= NOT bAMM_9428;			
	xMsg9428.PT	       		:= T#0s;			
	xMsg9428.Prio	   		:= 3;			
	xMsg9428.RiskClass		:= 4;				
	xMsg9428.Reset	   		:= FALSE;			
	xMsg9428();						
	MM2VIS.bMsg9428			:= xMsg9428.Q;			
							
	(* A9429 SAFETY - Software handshake not valid *)						
	xMsg9429.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9429.Set	  		:= NOT bAMM_9429;			
	xMsg9429.PT	       		:= T#0s;			
	xMsg9429.Prio	   		:= 3;			
	xMsg9429.RiskClass		:= 4;				
	xMsg9429.Reset	   		:= FALSE;			
	xMsg9429();						
	MM2VIS.bMsg9429			:= xMsg9429.Q;			

	(* A9430 SAFETY - Software not valid - Wrong CRC checksum *)						
	xMsg9430.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9430.Set	  		:= NOT bAMM_9430;			
	xMsg9430.PT	       		:= T#10m;			
	xMsg9430.Prio	   		:= 3;			
	xMsg9430.RiskClass		:= 4;				
	xMsg9430.Reset	   		:= FALSE;			
	xMsg9430();						
	MM2VIS.bMsg9430			:= xMsg9430.Q;			
							
	(* A9431 SAFETY - Parameter mismatch *)						
	xMsg9431.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9431.Set	  		:= NOT bAMM_9431;			
	xMsg9431.PT	       		:= T#0s;			
	xMsg9431.Prio	   		:= 3;			
	xMsg9431.RiskClass		:= 4;				
	xMsg9431.Reset	   		:= FALSE;			
	xMsg9431();						
	MM2VIS.bMsg9431			:= xMsg9431.Q;			
							
	(* A9433 SAFETY - Malfunction of safe communication channel  *)						
	xMsg9433.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9433.Set	  		:= NOT bAMM_9433;			
	xMsg9433.PT	       		:= T#0s;			
	xMsg9433.Prio	   		:= 3;			
	xMsg9433.RiskClass		:= 4;				
	xMsg9433.Reset	   		:= FALSE;			
	xMsg9433();						
	MM2VIS.bMsg9433			:= xMsg9433.Q;			

	(* A9434 SAFETY - Engine cooling water pump - Difference pressure minimum *)						
	xMsg9434.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9434.Set	  		:= NOT bAMM_9434;			
	xMsg9434.PT	       		:= T#0s;			
	xMsg9434.Prio	   		:= 3;			
	xMsg9434.RiskClass		:= 4;				
	xMsg9434.Reset	   		:= FALSE;			
	xMsg9434();						
	MM2VIS.bMsg9434			:= xMsg9434.Q;			
							
	(* A9437 SAFETY - Scavenging flap not closed *)						
	xMsg9437.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9437.Set	  		:= NOT bAMM_9437;			
	xMsg9437.PT	       		:= T#0s;			
	xMsg9437.Prio	   		:= 3;			
	xMsg9437.RiskClass		:= 4;				
	xMsg9437.Reset	   		:= FALSE;			
	xMsg9437();						
	MM2VIS.bMsg9437			:= xMsg9437.Q;			
							
	(* A9438 SAFETY - Scavenging flap failure *)						
	xMsg9438.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9438.Set	  		:= NOT bAMM_9438;			
	xMsg9438.PT	       		:= T#0s;			
	xMsg9438.Prio	   		:= 3;			
	xMsg9438.RiskClass		:= 4;				
	xMsg9438.Reset	   		:= FALSE;			
	xMsg9438();						
	MM2VIS.bMsg9438			:= xMsg9438.Q;			
							
	(* A9439 SAFETY - Engine cooling water temperature after engine maximum *)						
	xMsg9439.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9439.Set	  		:= NOT bAMM_9439;			
	xMsg9439.PT	       		:= T#1s;			
	xMsg9439.Prio	   		:= 3;			
	xMsg9439.RiskClass		:= 4;				
	xMsg9439.Reset	   		:= FALSE;			
	xMsg9439();						
	MM2VIS.bMsg9439			:= xMsg9439.Q;			
							
	(* A9440 SAFETY - Heating water supply temperature unit maximum *)						
	xMsg9440.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9440.Set	  		:= NOT bAMM_9440;			
	xMsg9440.PT	       		:= T#1s;			
	xMsg9440.Prio	   		:= 3;			
	xMsg9440.RiskClass		:= 4;				
	xMsg9440.Reset	   		:= FALSE;			
	xMsg9440();						
	MM2VIS.bMsg9440			:= xMsg9440.Q;			
							
	(* A9441 SAFETY - Customer heating water circuit failure *)						
	xMsg9441.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9441.Set	  		:= NOT bAMM_9441;			
	xMsg9441.PT	       		:= T#0s;			
	xMsg9441.Prio	   		:= 3;			
	xMsg9441.RiskClass		:= 4;				
	xMsg9441.Reset	   		:= FALSE;			
	xMsg9441();						
	MM2VIS.bMsg9441			:= xMsg9441.Q;			

	(* A9442 SAFETY - High temperature heating water level minimum *)						
	xMsg9442.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9442.Set	  		:= NOT bAMM_9442;			
	xMsg9442.PT	       		:= T#0s;			
	xMsg9442.Prio	   		:= 3;			
	xMsg9442.RiskClass		:= 4;				
	xMsg9442.Reset	   		:= FALSE;			
	xMsg9442();						
	MM2VIS.bMsg9442			:= xMsg9442.Q;			
							
	(* A9443 SAFETY - High temperature heating water pressure 1 maximum *)						
	xMsg9443.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9443.Set	  		:= NOT bAMM_9443;			
	xMsg9443.PT	       		:= T#0s;			
	xMsg9443.Prio	   		:= 3;			
	xMsg9443.RiskClass		:= 4;				
	xMsg9443.Reset	   		:= FALSE;			
	xMsg9443();						
	MM2VIS.bMsg9443			:= xMsg9443.Q;			
							
	(* A9444 SAFETY - High temperature heating water pressure 2 maximum *)						
	xMsg9444.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9444.Set	  		:= NOT bAMM_9444;			
	xMsg9444.PT	       		:= T#0s;			
	xMsg9444.Prio	   		:= 3;			
	xMsg9444.RiskClass		:= 4;				
	xMsg9444.Reset	   		:= FALSE;			
	xMsg9444();						
	MM2VIS.bMsg9444			:= xMsg9444.Q;			
	
	(* A9445 SAFETY - High temperature heating water pressure 1 minimum *)						
	xMsg9445.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9445.Set	  		:= NOT bAMM_9445;			
	xMsg9445.PT	       		:= T#0s;			
	xMsg9445.Prio	   		:= 3;			
	xMsg9445.RiskClass		:= 4;				
	xMsg9445.Reset	   		:= FALSE;			
	xMsg9445();						
	MM2VIS.bMsg9445			:= xMsg9445.Q;			
							
	(* A9446 SAFETY - High temperature heating water pressure 2 minimum *)						
	xMsg9446.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9446.Set	  		:= NOT bAMM_9446;			
	xMsg9446.PT	       		:= T#0s;			
	xMsg9446.Prio	   		:= 3;			
	xMsg9446.RiskClass		:= 4;				
	xMsg9446.Reset	   		:= FALSE;			
	xMsg9446();						
	MM2VIS.bMsg9446			:= xMsg9446.Q;			
							
	(* A9447 SAFETY - High temperature heating water temperature 1 maximum *)						
	xMsg9447.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9447.Set	  		:= NOT bAMM_9447;			
	xMsg9447.PT	       		:= T#0s;			
	xMsg9447.Prio	   		:= 3;			
	xMsg9447.RiskClass		:= 4;				
	xMsg9447.Reset	   		:= FALSE;			
	xMsg9447();						
	MM2VIS.bMsg9447			:= xMsg9447.Q;			

	(* A9448 SAFETY - High temperature heating water temperature 2 maximum *)						
	xMsg9448.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9448.Set	  		:= NOT bAMM_9448;			
	xMsg9448.PT	       		:= T#0s;			
	xMsg9448.Prio	   		:= 3;			
	xMsg9448.RiskClass		:= 4;				
	xMsg9448.Reset	   		:= FALSE;			
	xMsg9448();						
	MM2VIS.bMsg9448			:= xMsg9448.Q;			
							
	(* A9449 SAFETY - High temperature heating water flow minimum *)						
	xMsg9449.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9449.Set	  		:= NOT bAMM_9449;			
	xMsg9449.PT	       		:= T#0s;			
	xMsg9449.Prio	   		:= 3;			
	xMsg9449.RiskClass		:= 4;				
	xMsg9449.Reset	   		:= FALSE;			
	xMsg9449();						
	MM2VIS.bMsg9449			:= xMsg9449.Q;			
							
	(* A9450 SAFETY - Low temperature heating water level minimum *)						
	xMsg9450.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9450.Set	  		:= NOT bAMM_9450;			
	xMsg9450.PT	       		:= T#0s;			
	xMsg9450.Prio	   		:= 3;			
	xMsg9450.RiskClass		:= 4;				
	xMsg9450.Reset	   		:= FALSE;			
	xMsg9450();						
	MM2VIS.bMsg9450			:= xMsg9450.Q;			
							
	(* A9451 SAFETY - Low temperature heating water pressure 1 maximum *)						
	xMsg9451.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9451.Set	  		:= NOT bAMM_9451;			
	xMsg9451.PT	       		:= T#0s;			
	xMsg9451.Prio	   		:= 3;			
	xMsg9451.RiskClass		:= 4;				
	xMsg9451.Reset	   		:= FALSE;			
	xMsg9451();						
	MM2VIS.bMsg9451			:= xMsg9451.Q;			
							
	(* A9452 SAFETY - Low temperature heating water pressure 2 maximum *)						
	xMsg9452.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9452.Set	  		:= NOT bAMM_9452;			
	xMsg9452.PT	       		:= T#0s;			
	xMsg9452.Prio	   		:= 3;			
	xMsg9452.RiskClass		:= 4;				
	xMsg9452.Reset	   		:= FALSE;			
	xMsg9452();						
	MM2VIS.bMsg9452			:= xMsg9452.Q;			
							
	(* A9453 SAFETY - Low temperature heating water pressure 1 minimum *)						
	xMsg9453.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9453.Set	  		:= NOT bAMM_9453;			
	xMsg9453.PT	       		:= T#0s;			
	xMsg9453.Prio	   		:= 3;			
	xMsg9453.RiskClass		:= 4;				
	xMsg9453.Reset	   		:= FALSE;			
	xMsg9453();						
	MM2VIS.bMsg9453			:= xMsg9453.Q;			
							
	(* A9454 SAFETY - Low temperature heating water pressure 2 minimum *)						
	xMsg9454.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9454.Set	  		:= NOT bAMM_9454;			
	xMsg9454.PT	       		:= T#0s;			
	xMsg9454.Prio	   		:= 3;			
	xMsg9454.RiskClass		:= 4;				
	xMsg9454.Reset	   		:= FALSE;			
	xMsg9454();						
	MM2VIS.bMsg9454			:= xMsg9454.Q;			
							
	(* A9455 SAFETY - Low temperature heating water temperature 1 maximum *)						
	xMsg9455.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9455.Set	  		:= NOT bAMM_9455;			
	xMsg9455.PT	       		:= T#0s;			
	xMsg9455.Prio	   		:= 3;			
	xMsg9455.RiskClass		:= 4;				
	xMsg9455.Reset	   		:= FALSE;			
	xMsg9455();						
	MM2VIS.bMsg9455			:= xMsg9455.Q;			
							
	(* A9456 SAFETY - Low temperature heating water temperature 2 maximum *)						
	xMsg9456.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9456.Set	  		:= NOT bAMM_9456;			
	xMsg9456.PT	       		:= T#0s;			
	xMsg9456.Prio	   		:= 3;			
	xMsg9456.RiskClass		:= 4;				
	xMsg9456.Reset	   		:= FALSE;			
	xMsg9456();						
	MM2VIS.bMsg9456			:= xMsg9456.Q;			
							
	(* A9457 SAFETY - Low temperature heating water flow minimum *)						
	xMsg9457.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9457.Set	  		:= NOT bAMM_9457;			
	xMsg9457.PT	       		:= T#0s;			
	xMsg9457.Prio	   		:= 3;			
	xMsg9457.RiskClass		:= 4;				
	xMsg9457.Reset	   		:= FALSE;			
	xMsg9457();						
	MM2VIS.bMsg9457			:= xMsg9457.Q;			
							
	(* A9458 SAFETY - Safety loop 2 tripped - Module control panel *)						
	xMsg9458.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9458.Set	  		:= NOT bAMM_9458;			
	xMsg9458.PT	       		:= T#0s;			
	xMsg9458.Prio	   		:= 3;			
	xMsg9458.RiskClass		:= 4;				
	xMsg9458.Reset	   		:= FALSE;			
	xMsg9458();						
	MM2VIS.bMsg9458			:= xMsg9458.Q;			
							
	(* A9459 SAFETY - Safety loop tripped - Module interface panel *)						
	xMsg9459.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9459.Set	  		:= NOT bAMM_9459;			
	xMsg9459.PT	       		:= T#0s;			
	xMsg9459.Prio	   		:= 3;			
	xMsg9459.RiskClass		:= 4;				
	xMsg9459.Reset	   		:= FALSE;			
	xMsg9459();						
	MM2VIS.bMsg9459			:= xMsg9459.Q;			

	(* A9460 SAFETY - Emergency stop push button - Module control panel *)						
	xMsg9460.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9460.Set	  		:= NOT bAMM_9460;			
	xMsg9460.PT	       		:= T#1s;			
	xMsg9460.Prio	   		:= 3;			
	xMsg9460.RiskClass		:= 4;				
	xMsg9460.Reset	   		:= FALSE;			
	xMsg9460();						
	MM2VIS.bMsg9460			:= xMsg9460.Q;			
							
	(* A9461 SAFETY - Emergency stop push button - Engine room button 1 *)						
	xMsg9461.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9461.Set	  		:= NOT bAMM_9461;			
	xMsg9461.PT	       		:= T#1s;			
	xMsg9461.Prio	   		:= 3;			
	xMsg9461.RiskClass		:= 4;				
	xMsg9461.Reset	   		:= FALSE;			
	xMsg9461();						
	MM2VIS.bMsg9461			:= xMsg9461.Q;			
							
	(* A9462 SAFETY - Emergency stop push button - Engine room button 2 *)						
	xMsg9462.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9462.Set	  		:= NOT bAMM_9462;			
	xMsg9462.PT	       		:= T#1s;			
	xMsg9462.Prio	   		:= 3;			
	xMsg9462.RiskClass		:= 4;				
	xMsg9462.Reset	   		:= FALSE;			
	xMsg9462();						
	MM2VIS.bMsg9462			:= xMsg9462.Q;			
											
	(* A9463 SAFETY - Emergency stop push button - Engine room button 3 *)						
	xMsg9463.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9463.Set	  		:= NOT bAMM_9463;			
	xMsg9463.PT	       		:= T#1s;			
	xMsg9463.Prio	   		:= 3;			
	xMsg9463.RiskClass		:= 4;				
	xMsg9463.Reset	   		:= FALSE;			
	xMsg9463();						
	MM2VIS.bMsg9463			:= xMsg9463.Q;			
							
	(* A9464 SAFETY - Emergency stop push button - Engine room button 4 *)						
	xMsg9464.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9464.Set	  		:= NOT bAMM_9464;			
	xMsg9464.PT	       		:= T#1s;			
	xMsg9464.Prio	   		:= 3;			
	xMsg9464.RiskClass		:= 4;				
	xMsg9464.Reset	   		:= FALSE;			
	xMsg9464();						
	MM2VIS.bMsg9464			:= xMsg9464.Q;			
							
	(* A9465 SAFETY - Emergency stop push button - External *)						
	xMsg9465.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9465.Set	  		:= NOT bAMM_9465;			
	xMsg9465.PT	       		:= T#1s;			
	xMsg9465.Prio	   		:= 3;			
	xMsg9465.RiskClass		:= 4;				
	xMsg9465.Reset	   		:= FALSE;			
	xMsg9465();						
	MM2VIS.bMsg9465			:= xMsg9465.Q;			
		
	(* A9466 SAFETY - Emergency stop push button - Thermal reactor control panel *)						
	xMsg9466.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9466.Set	  		:= NOT bAMM_9466;			
	xMsg9466.PT	       		:= T#1s;			
	xMsg9466.Prio	   		:= 3;			
	xMsg9466.RiskClass		:= 4;				
	xMsg9466.Reset	   		:= FALSE;			
	xMsg9466();						
	MM2VIS.bMsg9466			:= xMsg9466.Q;			
							
	(* A9467 SAFETY - Emergency stop push button - Interlock control panel *)						
	xMsg9467.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9467.Set	  		:= NOT bAMM_9467;			
	xMsg9467.PT	       		:= T#1s;			
	xMsg9467.Prio	   		:= 3;			
	xMsg9467.RiskClass		:= 4;				
	xMsg9467.Reset	   		:= FALSE;			
	xMsg9467();						
	MM2VIS.bMsg9467			:= xMsg9467.Q;			
							
	(* A9468 SAFETY - Emergency stop push button - Master control panel *)						
	xMsg9468.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9468.Set	  		:= NOT bAMM_9468;			
	xMsg9468.PT	       		:= T#1s;			
	xMsg9468.Prio	   		:= 3;			
	xMsg9468.RiskClass		:= 4;				
	xMsg9468.Reset	   		:= FALSE;			
	xMsg9468();						
	MM2VIS.bMsg9468			:= xMsg9468.Q;			
	
	(* A9469 SAFETY - Emergency stop push button - Exhaust gas after treatment control panel *)						
	xMsg9469.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9469.Set	  		:= NOT bAMM_9469;			
	xMsg9469.PT	       		:= T#1s;			
	xMsg9469.Prio	   		:= 3;			
	xMsg9469.RiskClass		:= 4;				
	xMsg9469.Reset	   		:= FALSE;			
	xMsg9469();						
	MM2VIS.bMsg9469			:= xMsg9469.Q;			
							
	(* A9470 SAFETY - Emergency stop push button - Prechamber gas compressor *)						
	xMsg9470.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9470.Set	  		:= NOT bAMM_9470;			
	xMsg9470.PT	       		:= T#1s;			
	xMsg9470.Prio	   		:= 3;			
	xMsg9470.RiskClass		:= 4;				
	xMsg9470.Reset	   		:= FALSE;			
	xMsg9470();						
	MM2VIS.bMsg9470			:= xMsg9470.Q;			
							
	(* A9471 SAFETY - Emergency stop push button - Auxiliaries control panel *)						
	xMsg9471.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9471.Set	  		:= NOT bAMM_9471;			
	xMsg9471.PT	       		:= T#1s;			
	xMsg9471.Prio	   		:= 3;			
	xMsg9471.RiskClass		:= 4;				
	xMsg9471.Reset	   		:= FALSE;			
	xMsg9471();						
	MM2VIS.bMsg9471			:= xMsg9471.Q;			
	
	(* A9480 SAFETY - Room ventilation failure - Doors *)						
	xMsg9480.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9480.Set	  		:= NOT bAMM_9480;			
	xMsg9480.PT	       		:= T#0s;			
	xMsg9480.Prio	   		:= 3;			
	xMsg9480.RiskClass		:= 4;				
	xMsg9480.Reset	   		:= FALSE;			
	xMsg9480();						
	MM2VIS.bMsg9480			:= xMsg9480.Q;			
							
	(* A9481 SAFETY - Room ventilation failure - Inlet air fan *)						
	xMsg9481.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9481.Set	  		:= NOT bAMM_9481;			
	xMsg9481.PT	       		:= T#0s;			
	xMsg9481.Prio	   		:= 3;			
	xMsg9481.RiskClass		:= 4;				
	xMsg9481.Reset	   		:= FALSE;			
	xMsg9481();						
	MM2VIS.bMsg9481			:= xMsg9481.Q;			
							
	(* A9482 SAFETY - Room ventilation failure - Inlet air louvre *)						
	xMsg9482.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9482.Set	  		:= NOT bAMM_9482;			
	xMsg9482.PT	       		:= T#0s;			
	xMsg9482.Prio	   		:= 3;			
	xMsg9482.RiskClass		:= 4;				
	xMsg9482.Reset	   		:= FALSE;			
	xMsg9482();						
	MM2VIS.bMsg9482			:= xMsg9482.Q;			
	
	(* A9483 SAFETY - Room ventilation failure - Outlet air louvre *)						
	xMsg9483.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9483.Set	  		:= NOT bAMM_9483;			
	xMsg9483.PT	       		:= T#0s;			
	xMsg9483.Prio	   		:= 3;			
	xMsg9483.RiskClass		:= 4;				
	xMsg9483.Reset	   		:= FALSE;			
	xMsg9483();						
	MM2VIS.bMsg9483			:= xMsg9483.Q;			
							
	(* A9484 SAFETY - Failure gas train for decentral gas addition *)						
	xMsg9484.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9484.Set	  		:= NOT bAMM_9484;			
	xMsg9484.PT	       		:= T#0s;			
	xMsg9484.Prio	   		:= 3;			
	xMsg9484.RiskClass		:= 4;				
	xMsg9484.Reset	   		:= FALSE;			
	xMsg9484();						
	MM2VIS.bMsg9484			:= xMsg9484.Q;			



	(* W9508 SAFETY - Malfunction of safe communication channel - Node 210 *)						
	xMsg9508.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9508.Set	  		:= NOT bAMM_9508;			
	xMsg9508.PT	       		:= T#0s;			
	xMsg9508.Prio	   		:= 4;			
	xMsg9508.RiskClass		:= 4;				
	xMsg9508.Reset	   		:= FALSE;			
	xMsg9508();						
	MM2VIS.bMsg9508			:= xMsg9508.Q;			
	
	(* W9514 SAFETY - Speed signal not valid *)						
	xMsg9514.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9514.Set	  		:= NOT bAMM_9514;			
	xMsg9514.PT	       		:= T#0s;			
	xMsg9514.Prio	   		:= 4;			
	xMsg9514.RiskClass		:= 4;				
	xMsg9514.Reset	   		:= FALSE;			
	xMsg9514();						
	MM2VIS.bMsg9514			:= xMsg9514.Q;			
							
	(* W9515 SAFETY - Ignition plausibility check failure *)						
	xMsg9515.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9515.Set	  		:= NOT bAMM_9515;			
	xMsg9515.PT	       		:= T#0s;			
	xMsg9515.Prio	   		:= 4;			
	xMsg9515.RiskClass		:= 4;				
	xMsg9515.Reset	   		:= FALSE;			
	xMsg9515();						
	MM2VIS.bMsg9515			:= xMsg9515.Q;			
							
	(* W9516 SAFETY - Ignition system running - signal not valid *)						
	xMsg9516.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9516.Set	  		:= NOT bAMM_9516;			
	xMsg9516.PT	       		:= T#0s;			
	xMsg9516.Prio	   		:= 4;			
	xMsg9516.RiskClass		:= 4;				
	xMsg9516.Reset	   		:= FALSE;			
	xMsg9516();						
	MM2VIS.bMsg9516			:= xMsg9516.Q;			
	
	(* W9517 SAFETY - Release of synchronizing and load - output not valid *)						
	xMsg9517.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9517.Set	  		:= NOT bAMM_9517;			
	xMsg9517.PT	       		:= T#0s;			
	xMsg9517.Prio	   		:= 4;			
	xMsg9517.RiskClass		:= 4;				
	xMsg9517.Reset	   		:= FALSE;			
	xMsg9517();						
	MM2VIS.bMsg9517			:= xMsg9517.Q;			
							
	(* W9518 SAFETY - Generator circuit breaker release undervoltage trip coil - output not valid *)
	xMsg9518.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9518.Set	  		:= NOT bAMM_9518;			
	xMsg9518.PT	       		:= T#0s;			
	xMsg9518.Prio	   		:= 4;			
	xMsg9518.RiskClass		:= 4;				
	xMsg9518.Reset	   		:= FALSE;			
	xMsg9518();						
	MM2VIS.bMsg9518			:= xMsg9518.Q;			
							
	(* W9519 SAFETY - Generator circuit breaker position ON - signal not valid *)						
	xMsg9519.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9519.Set	  		:= NOT bAMM_9519;			
	xMsg9519.PT	       		:= T#0s;			
	xMsg9519.Prio	   		:= 4;			
	xMsg9519.RiskClass		:= 4;				
	xMsg9519.Reset	   		:= FALSE;			
	xMsg9519();						
	MM2VIS.bMsg9519			:= xMsg9519.Q;			
	
	(* W9520 SAFETY - Generator circuit breaker position OFF - signal not valid *)						
	xMsg9520.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9520.Set	  		:= NOT bAMM_9520;			
	xMsg9520.PT	       		:= T#0s;			
	xMsg9520.Prio	   		:= 4;			
	xMsg9520.RiskClass		:= 4;				
	xMsg9520.Reset	   		:= FALSE;			
	xMsg9520();						
	MM2VIS.bMsg9520			:= xMsg9520.Q;			
							
	(* W9521 SAFETY - Generator overload/short circuit - signal not valid *)						
	xMsg9521.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9521.Set	  		:= NOT bAMM_9521;			
	xMsg9521.PT	       		:= T#0s;			
	xMsg9521.Prio	   		:= 4;			
	xMsg9521.RiskClass		:= 4;				
	xMsg9521.Reset	   		:= FALSE;			
	xMsg9521();						
	MM2VIS.bMsg9521			:= xMsg9521.Q;			
							
	(* W9522 SAFETY - Generator protection trip - signal not valid *)						
	xMsg9522.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9522.Set	  		:= NOT bAMM_9522;			
	xMsg9522.PT	       		:= T#0s;			
	xMsg9522.Prio	   		:= 4;			
	xMsg9522.RiskClass		:= 4;				
	xMsg9522.Reset	   		:= FALSE;			
	xMsg9522();						
	MM2VIS.bMsg9522			:= xMsg9522.Q;			
	
	(* W9523 SAFETY - Collective fault in room ventilation - plausibility check failure *)						
	xMsg9523.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9523.Set	  		:= NOT bAMM_9523;			
	xMsg9523.PT	       		:= T#0s;			
	xMsg9523.Prio	   		:= 4;			
	xMsg9523.RiskClass		:= 4;				
	xMsg9523.Reset	   		:= FALSE;			
	xMsg9523();						
	MM2VIS.bMsg9523			:= xMsg9523.Q;			
							
	(* W9524 SAFETY - Collective fault in room ventilation - signal not valid *)						
	xMsg9524.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9524.Set	  		:= NOT bAMM_9524;			
	xMsg9524.PT	       		:= T#0s;			
	xMsg9524.Prio	   		:= 4;			
	xMsg9524.RiskClass		:= 4;				
	xMsg9524.Reset	   		:= FALSE;			
	xMsg9524();						
	MM2VIS.bMsg9524			:= xMsg9524.Q;			
							
	(* W9525 SAFETY - Emergency stop push button - Module interface panel - signal not valid *)						
	xMsg9525.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9525.Set	  		:= NOT bAMM_9525;			
	xMsg9525.PT	       		:= T#0s;			
	xMsg9525.Prio	   		:= 4;			
	xMsg9525.RiskClass		:= 4;				
	xMsg9525.Reset	   		:= FALSE;			
	xMsg9525();						
	MM2VIS.bMsg9525			:= xMsg9525.Q;			
	
	(* W9526 SAFETY - Emergency stop push button - signal not valid *)						
	xMsg9526.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9526.Set	  		:= NOT bAMM_9526;			
	xMsg9526.PT	       		:= T#0s;			
	xMsg9526.Prio	   		:= 4;			
	xMsg9526.RiskClass		:= 4;				
	xMsg9526.Reset	   		:= FALSE;			
	xMsg9526();						
	MM2VIS.bMsg9526			:= xMsg9526.Q;			
							
	(* W9527 SAFETY - Safety loop 1 - Module control panel - signal not valid *)						
	xMsg9527.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9527.Set	  		:= NOT bAMM_9527;			
	xMsg9527.PT	       		:= T#0s;			
	xMsg9527.Prio	   		:= 4;			
	xMsg9527.RiskClass		:= 4;				
	xMsg9527.Reset	   		:= FALSE;			
	xMsg9527();						
	MM2VIS.bMsg9527			:= xMsg9527.Q;			
							
	(* W9528 SAFETY - Release gas valve 1a - output not valid *)						
	xMsg9528.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9528.Set	  		:= NOT bAMM_9528;			
	xMsg9528.PT	       		:= T#0s;			
	xMsg9528.Prio	   		:= 4;			
	xMsg9528.RiskClass		:= 4;				
	xMsg9528.Reset	   		:= FALSE;			
	xMsg9528();						
	MM2VIS.bMsg9528			:= xMsg9528.Q;			
	
	(* W9529 SAFETY - Release gas valve 1b - output not valid *)						
	xMsg9529.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9529.Set	  		:= NOT bAMM_9529;			
	xMsg9529.PT	       		:= T#0s;			
	xMsg9529.Prio	   		:= 4;			
	xMsg9529.RiskClass		:= 4;				
	xMsg9529.Reset	   		:= FALSE;			
	xMsg9529();						
	MM2VIS.bMsg9529			:= xMsg9529.Q;			
							
	(* W9530 SAFETY - Release gas valve 2a - output not valid *)						
	xMsg9530.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9530.Set	  		:= NOT bAMM_9530;			
	xMsg9530.PT	       		:= T#0s;			
	xMsg9530.Prio	   		:= 4;			
	xMsg9530.RiskClass		:= 4;				
	xMsg9530.Reset	   		:= FALSE;			
	xMsg9530();						
	MM2VIS.bMsg9530			:= xMsg9530.Q;			
							
	(* W9531 SAFETY - Release gas valve 2b - output not valid *)						
	xMsg9531.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9531.Set	  		:= NOT bAMM_9531;			
	xMsg9531.PT	       		:= T#0s;			
	xMsg9531.Prio	   		:= 4;			
	xMsg9531.RiskClass		:= 4;				
	xMsg9531.Reset	   		:= FALSE;			
	xMsg9531();						
	MM2VIS.bMsg9531			:= xMsg9531.Q;			
	
	(* W9532 SAFETY - Release gas valve 3a - output not valid *)						
	xMsg9532.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9532.Set	  		:= NOT bAMM_9532;			
	xMsg9532.PT	       		:= T#0s;			
	xMsg9532.Prio	   		:= 4;			
	xMsg9532.RiskClass		:= 4;				
	xMsg9532.Reset	   		:= FALSE;			
	xMsg9532();						
	MM2VIS.bMsg9532			:= xMsg9532.Q;			
							
	(* W9533 SAFETY - Release gas valve 3b - output not valid *)						
	xMsg9533.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9533.Set	  		:= NOT bAMM_9533;			
	xMsg9533.PT	       		:= T#0s;			
	xMsg9533.Prio	   		:= 4;			
	xMsg9533.RiskClass		:= 4;				
	xMsg9533.Reset	   		:= FALSE;			
	xMsg9533();						
	MM2VIS.bMsg9533			:= xMsg9533.Q;			
								
	(* W9534 SAFETY - Release gas valve 4a - output not valid *)						
	xMsg9534.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9534.Set	  		:= NOT bAMM_9534;			
	xMsg9534.PT	       		:= T#0s;			
	xMsg9534.Prio	   		:= 4;			
	xMsg9534.RiskClass		:= 4;				
	xMsg9534.Reset	   		:= FALSE;			
	xMsg9534();						
	MM2VIS.bMsg9534			:= xMsg9534.Q;			
							
	(* W9535 SAFETY - Release gas valve 4b - output not valid *)						
	xMsg9535.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9535.Set	  		:= NOT bAMM_9535;			
	xMsg9535.PT	       		:= T#0s;			
	xMsg9535.Prio	   		:= 4;			
	xMsg9535.RiskClass		:= 4;				
	xMsg9535.Reset	   		:= FALSE;			
	xMsg9535();						
	MM2VIS.bMsg9535			:= xMsg9535.Q;			
							
	(* W9536 SAFETY - Gas safety device 1 - signal not valid *)						
	xMsg9536.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9536.Set	  		:= NOT bAMM_9536;			
	xMsg9536.PT	       		:= T#0s;			
	xMsg9536.Prio	   		:= 4;			
	xMsg9536.RiskClass		:= 4;				
	xMsg9536.Reset	   		:= FALSE;			
	xMsg9536();						
	MM2VIS.bMsg9536			:= xMsg9536.Q;			

	(* W9537 SAFETY - Gas safety device 2 - signal not valid *)						
	xMsg9537.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9537.Set	  		:= NOT bAMM_9537;			
	xMsg9537.PT	       		:= T#0s;			
	xMsg9537.Prio	   		:= 4;			
	xMsg9537.RiskClass		:= 4;				
	xMsg9537.Reset	   		:= FALSE;			
	xMsg9537();						
	MM2VIS.bMsg9537			:= xMsg9537.Q;			
							
	(* W9538 SAFETY - Gas safety device 3 - signal not valid *)						
	xMsg9538.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9538.Set	  		:= NOT bAMM_9538;			
	xMsg9538.PT	       		:= T#0s;			
	xMsg9538.Prio	   		:= 4;			
	xMsg9538.RiskClass		:= 4;				
	xMsg9538.Reset	   		:= FALSE;			
	xMsg9538();						
	MM2VIS.bMsg9538			:= xMsg9538.Q;			
							
	(* W9539 SAFETY - Gas safety device 4 - signal not valid *)						
	xMsg9539.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9539.Set	  		:= NOT bAMM_9539;			
	xMsg9539.PT	       		:= T#0s;			
	xMsg9539.Prio	   		:= 4;			
	xMsg9539.RiskClass		:= 4;				
	xMsg9539.Reset	   		:= FALSE;			
	xMsg9539();						
	MM2VIS.bMsg9539			:= xMsg9539.Q;			

	(* W9540 SAFETY - Gas safety device 1 - output not valid *)						
	xMsg9540.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9540.Set	  		:= NOT bAMM_9540;			
	xMsg9540.PT	       		:= T#0s;			
	xMsg9540.Prio	   		:= 4;			
	xMsg9540.RiskClass		:= 4;				
	xMsg9540.Reset	   		:= FALSE;			
	xMsg9540();						
	MM2VIS.bMsg9540			:= xMsg9540.Q;			
							
	(* W9541 SAFETY - Gas safety device 2 - output not valid *)						
	xMsg9541.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9541.Set	  		:= NOT bAMM_9541;			
	xMsg9541.PT	       		:= T#0s;			
	xMsg9541.Prio	   		:= 4;			
	xMsg9541.RiskClass		:= 4;				
	xMsg9541.Reset	   		:= FALSE;			
	xMsg9541();						
	MM2VIS.bMsg9541			:= xMsg9541.Q;			
							
	(* W9542 SAFETY - Gas safety device 3 - output not valid *)						
	xMsg9542.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9542.Set	  		:= NOT bAMM_9542;			
	xMsg9542.PT	       		:= T#0s;			
	xMsg9542.Prio	   		:= 4;			
	xMsg9542.RiskClass		:= 4;				
	xMsg9542.Reset	   		:= FALSE;			
	xMsg9542();						
	MM2VIS.bMsg9542			:= xMsg9542.Q;			
							
	(* W9543 SAFETY - Gas safety device 4 - output not valid *)						
	xMsg9543.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9543.Set	  		:= NOT bAMM_9543;			
	xMsg9543.PT	       		:= T#0s;			
	xMsg9543.Prio	   		:= 4;			
	xMsg9543.RiskClass		:= 4;				
	xMsg9543.Reset	   		:= FALSE;			
	xMsg9543();						
	MM2VIS.bMsg9543			:= xMsg9543.Q;			
							
	(* W9544 SAFETY - Malfunction of safe communication channel - Node 101 *)						
	xMsg9544.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9544.Set	  		:= NOT bAMM_9544;			
	xMsg9544.PT	       		:= T#0s;			
	xMsg9544.Prio	   		:= 4;			
	xMsg9544.RiskClass		:= 4;				
	xMsg9544.Reset	   		:= FALSE;			
	xMsg9544();						
	MM2VIS.bMsg9544			:= xMsg9544.Q;			
							
	(* W9545 SAFETY - Malfunction of safe communication channel - Node 102 *)						
	xMsg9545.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9545.Set	  		:= NOT bAMM_9545;			
	xMsg9545.PT	       		:= T#0s;			
	xMsg9545.Prio	   		:= 4;			
	xMsg9545.RiskClass		:= 4;				
	xMsg9545.Reset	   		:= FALSE;			
	xMsg9545();						
	MM2VIS.bMsg9545			:= xMsg9545.Q;			

	(* W9546 SAFETY - Malfunction of safe communication channel - Node 103 *)						
	xMsg9546.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9546.Set	  		:= NOT bAMM_9546;			
	xMsg9546.PT	       		:= T#0s;			
	xMsg9546.Prio	   		:= 4;			
	xMsg9546.RiskClass		:= 4;				
	xMsg9546.Reset	   		:= FALSE;			
	xMsg9546();						
	MM2VIS.bMsg9546			:= xMsg9546.Q;			
							
	(* W9547 SAFETY - Malfunction of safe communication channel - Node 104 *)						
	xMsg9547.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9547.Set	  		:= NOT bAMM_9547;			
	xMsg9547.PT	       		:= T#0s;			
	xMsg9547.Prio	   		:= 4;			
	xMsg9547.RiskClass		:= 4;				
	xMsg9547.Reset	   		:= FALSE;			
	xMsg9547();						
	MM2VIS.bMsg9547			:= xMsg9547.Q;			
							
	(* W9548 SAFETY - Malfunction of safe communication channel - Node 201 *)						
	xMsg9548.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9548.Set	  		:= NOT bAMM_9548;			
	xMsg9548.PT	       		:= T#0s;			
	xMsg9548.Prio	   		:= 4;			
	xMsg9548.RiskClass		:= 4;				
	xMsg9548.Reset	   		:= FALSE;			
	xMsg9548();						
	MM2VIS.bMsg9548			:= xMsg9548.Q;			
							
	(* W9549 SAFETY - Malfunction of safe communication channel - Node 202 *)						
	xMsg9549.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9549.Set	  		:= NOT bAMM_9549;			
	xMsg9549.PT	       		:= T#0s;			
	xMsg9549.Prio	   		:= 4;			
	xMsg9549.RiskClass		:= 4;				
	xMsg9549.Reset	   		:= FALSE;			
	xMsg9549();						
	MM2VIS.bMsg9549			:= xMsg9549.Q;			
							
	(* W9550 SAFETY - Malfunction of safe communication channel - Node 203 *)						
	xMsg9550.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9550.Set	  		:= NOT bAMM_9550;			
	xMsg9550.PT	       		:= T#0s;			
	xMsg9550.Prio	   		:= 4;			
	xMsg9550.RiskClass		:= 4;				
	xMsg9550.Reset	   		:= FALSE;			
	xMsg9550();						
	MM2VIS.bMsg9550			:= xMsg9550.Q;			
							
	(* W9551 SAFETY - Malfunction of safe communication channel - Node 204 *)						
	xMsg9551.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9551.Set	  		:= NOT bAMM_9551;			
	xMsg9551.PT	       		:= T#0s;			
	xMsg9551.Prio	   		:= 4;			
	xMsg9551.RiskClass		:= 4;				
	xMsg9551.Reset	   		:= FALSE;			
	xMsg9551();						
	MM2VIS.bMsg9551			:= xMsg9551.Q;			

	(* W9552 SAFETY - Malfunction of safe communication channel - Node 205 *)						
	xMsg9552.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9552.Set	  		:= NOT bAMM_9552;			
	xMsg9552.PT	       		:= T#0s;			
	xMsg9552.Prio	   		:= 4;			
	xMsg9552.RiskClass		:= 4;				
	xMsg9552.Reset	   		:= FALSE;			
	xMsg9552();						
	MM2VIS.bMsg9552			:= xMsg9552.Q;			
							
	(* W9553 SAFETY - Malfunction of safe communication channel - Node 206 *)						
	xMsg9553.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9553.Set	  		:= NOT bAMM_9553;			
	xMsg9553.PT	       		:= T#0s;			
	xMsg9553.Prio	   		:= 4;			
	xMsg9553.RiskClass		:= 4;				
	xMsg9553.Reset	   		:= FALSE;			
	xMsg9553();						
	MM2VIS.bMsg9553			:= xMsg9553.Q;			
							
	(* W9554 SAFETY - Malfunction of safe communication channel - Node 207 *)						
	xMsg9554.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9554.Set	  		:= NOT bAMM_9554;			
	xMsg9554.PT	       		:= T#0s;			
	xMsg9554.Prio	   		:= 4;			
	xMsg9554.RiskClass		:= 4;				
	xMsg9554.Reset	   		:= FALSE;			
	xMsg9554();						
	MM2VIS.bMsg9554			:= xMsg9554.Q;			

	(* W9555 SAFETY - Malfunction of safe communication channel - Node 208 *)						
	xMsg9555.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9555.Set	  		:= NOT bAMM_9555;			
	xMsg9555.PT	       		:= T#0s;			
	xMsg9555.Prio	   		:= 4;			
	xMsg9555.RiskClass		:= 4;				
	xMsg9555.Reset	   		:= FALSE;			
	xMsg9555();						
	MM2VIS.bMsg9555			:= xMsg9555.Q;			
							
	(* W9556 SAFETY - Malfunction of safe communication channel - Node 209 *)						
	xMsg9556.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9556.Set	  		:= NOT bAMM_9556;			
	xMsg9556.PT	       		:= T#0s;			
	xMsg9556.Prio	   		:= 4;			
	xMsg9556.RiskClass		:= 4;				
	xMsg9556.Reset	   		:= FALSE;			
	xMsg9556();						
	MM2VIS.bMsg9556			:= xMsg9556.Q;			


	(* W9562 SAFETY - Scavenging flap plausibility check failure *)						
	xMsg9562.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9562.Set	  		:= NOT bAMM_9562;			
	xMsg9562.PT	       		:= T#0s;			
	xMsg9562.Prio	   		:= 4;			
	xMsg9562.RiskClass		:= 4;				
	xMsg9562.Reset	   		:= FALSE;			
	xMsg9562();						
	MM2VIS.bMsg9562			:= xMsg9562.Q;			
							
	(* W9563 SAFETY - Scavenging flap closed feedback - signal not valid *)						
	xMsg9563.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9563.Set	  		:= NOT bAMM_9563;			
	xMsg9563.PT	       		:= T#0s;			
	xMsg9563.Prio	   		:= 4;			
	xMsg9563.RiskClass		:= 4;				
	xMsg9563.Reset	   		:= FALSE;			
	xMsg9563();						
	MM2VIS.bMsg9563			:= xMsg9563.Q;			
							
	(* W9564 SAFETY - Scavenging flap temperature switch - signal not valid *)						
	xMsg9564.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9564.Set	  		:= NOT bAMM_9564;			
	xMsg9564.PT	       		:= T#0s;			
	xMsg9564.Prio	   		:= 4;			
	xMsg9564.RiskClass		:= 4;				
	xMsg9564.Reset	   		:= FALSE;			
	xMsg9564();						
	MM2VIS.bMsg9564			:= xMsg9564.Q;			
	
	(* W9565 SAFETY - Customer heating water circuit failure - signal not valid *)						
	xMsg9565.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9565.Set	  		:= NOT bAMM_9565;			
	xMsg9565.PT	       		:= T#0s;			
	xMsg9565.Prio	   		:= 4;			
	xMsg9565.RiskClass		:= 4;				
	xMsg9565.Reset	   		:= FALSE;			
	xMsg9565();						
	MM2VIS.bMsg9565			:= xMsg9565.Q;			
							
	(* W9566 SAFETY - High temperature heating water flow minimum - plausibility check failure *)						
	xMsg9566.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9566.Set	  		:= NOT bAMM_9566;			
	xMsg9566.PT	       		:= T#0s;			
	xMsg9566.Prio	   		:= 4;			
	xMsg9566.RiskClass		:= 4;				
	xMsg9566.Reset	   		:= FALSE;			
	xMsg9566();						
	MM2VIS.bMsg9566			:= xMsg9566.Q;			
							
	(* W9567 SAFETY - High temperature heating water level minimum - signal not valid *)						
	xMsg9567.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9567.Set	  		:= NOT bAMM_9567;			
	xMsg9567.PT	       		:= T#0s;			
	xMsg9567.Prio	   		:= 4;			
	xMsg9567.RiskClass		:= 4;				
	xMsg9567.Reset	   		:= FALSE;			
	xMsg9567();						
	MM2VIS.bMsg9567			:= xMsg9567.Q;			
	
	(* W9568 SAFETY - High temperature heating water pressure 1 maximum - signal not valid *)						
	xMsg9568.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9568.Set	  		:= NOT bAMM_9568;			
	xMsg9568.PT	       		:= T#0s;			
	xMsg9568.Prio	   		:= 4;			
	xMsg9568.RiskClass		:= 4;				
	xMsg9568.Reset	   		:= FALSE;			
	xMsg9568();						
	MM2VIS.bMsg9568			:= xMsg9568.Q;			
							
	(* W9569 SAFETY - High temperature heating water pressure 2 maximum - signal not valid *)						
	xMsg9569.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9569.Set	  		:= NOT bAMM_9569;			
	xMsg9569.PT	       		:= T#0s;			
	xMsg9569.Prio	   		:= 4;			
	xMsg9569.RiskClass		:= 4;				
	xMsg9569.Reset	   		:= FALSE;			
	xMsg9569();						
	MM2VIS.bMsg9569			:= xMsg9569.Q;			
							
	(* W9570 SAFETY - High temperature heating water pressure 1 minimum - signal not valid *)						
	xMsg9570.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9570.Set	  		:= NOT bAMM_9570;			
	xMsg9570.PT	       		:= T#0s;			
	xMsg9570.Prio	   		:= 4;			
	xMsg9570.RiskClass		:= 4;				
	xMsg9570.Reset	   		:= FALSE;			
	xMsg9570();						
	MM2VIS.bMsg9570			:= xMsg9570.Q;			
		
	(* W9571 SAFETY - High temperature heating water pressure 2 minimum - signal not valid *)						
	xMsg9571.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9571.Set	  		:= NOT bAMM_9571;			
	xMsg9571.PT	       		:= T#0s;			
	xMsg9571.Prio	   		:= 4;			
	xMsg9571.RiskClass		:= 4;				
	xMsg9571.Reset	   		:= FALSE;			
	xMsg9571();						
	MM2VIS.bMsg9571			:= xMsg9571.Q;			
							
	(* W9572 SAFETY - High temperature heating water temperature 1 maximum - signal not valid *)						
	xMsg9572.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9572.Set	  		:= NOT bAMM_9572;			
	xMsg9572.PT	       		:= T#0s;			
	xMsg9572.Prio	   		:= 4;			
	xMsg9572.RiskClass		:= 4;				
	xMsg9572.Reset	   		:= FALSE;			
	xMsg9572();						
	MM2VIS.bMsg9572			:= xMsg9572.Q;			
							
	(* W9573 SAFETY - High temperature heating water temperature 2 maximum - signal not valid *)						
	xMsg9573.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9573.Set	  		:= NOT bAMM_9573;			
	xMsg9573.PT	       		:= T#0s;			
	xMsg9573.Prio	   		:= 4;			
	xMsg9573.RiskClass		:= 4;				
	xMsg9573.Reset	   		:= FALSE;			
	xMsg9573();						
	MM2VIS.bMsg9573			:= xMsg9573.Q;			
	
	(* W9574 SAFETY - High temperature heating water flow minimum - signal not valid *)						
	xMsg9574.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9574.Set	  		:= NOT bAMM_9574;			
	xMsg9574.PT	       		:= T#0s;			
	xMsg9574.Prio	   		:= 4;			
	xMsg9574.RiskClass		:= 4;				
	xMsg9574.Reset	   		:= FALSE;			
	xMsg9574();						
	MM2VIS.bMsg9574			:= xMsg9574.Q;			
							
	(* W9575 SAFETY - Low temperature heating water flow minimum - plausibility check failure *)						
	xMsg9575.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9575.Set	  		:= NOT bAMM_9575;			
	xMsg9575.PT	       		:= T#0s;			
	xMsg9575.Prio	   		:= 4;			
	xMsg9575.RiskClass		:= 4;				
	xMsg9575.Reset	   		:= FALSE;			
	xMsg9575();						
	MM2VIS.bMsg9575			:= xMsg9575.Q;			
							
	(* W9576 SAFETY - Low temperature heating water level minimum - signal not valid *)						
	xMsg9576.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9576.Set	  		:= NOT bAMM_9576;			
	xMsg9576.PT	       		:= T#0s;			
	xMsg9576.Prio	   		:= 4;			
	xMsg9576.RiskClass		:= 4;				
	xMsg9576.Reset	   		:= FALSE;			
	xMsg9576();						
	MM2VIS.bMsg9576			:= xMsg9576.Q;			
	
	(* W9577 SAFETY - Low temperature heating water pressure 1 maximum - signal not valid *)						
	xMsg9577.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9577.Set	  		:= NOT bAMM_9577;			
	xMsg9577.PT	       		:= T#0s;			
	xMsg9577.Prio	   		:= 4;			
	xMsg9577.RiskClass		:= 4;				
	xMsg9577.Reset	   		:= FALSE;			
	xMsg9577();						
	MM2VIS.bMsg9577			:= xMsg9577.Q;			
							
	(* W9578 SAFETY - Low temperature heating water pressure 2 maximum - signal not valid *)						
	xMsg9578.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9578.Set	  		:= NOT bAMM_9578;			
	xMsg9578.PT	       		:= T#0s;			
	xMsg9578.Prio	   		:= 4;			
	xMsg9578.RiskClass		:= 4;				
	xMsg9578.Reset	   		:= FALSE;			
	xMsg9578();						
	MM2VIS.bMsg9578			:= xMsg9578.Q;			
							
	(* W9579 SAFETY - Low temperature heating water pressure 1 minimum - signal not valid *)						
	xMsg9579.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9579.Set	  		:= NOT bAMM_9579;			
	xMsg9579.PT	       		:= T#0s;			
	xMsg9579.Prio	   		:= 4;			
	xMsg9579.RiskClass		:= 4;				
	xMsg9579.Reset	   		:= FALSE;			
	xMsg9579();						
	MM2VIS.bMsg9579			:= xMsg9579.Q;			
		
	(* W9580 SAFETY - Low temperature heating water pressure 2 minimum - signal not valid *)						
	xMsg9580.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9580.Set	  		:= NOT bAMM_9580;			
	xMsg9580.PT	       		:= T#0s;			
	xMsg9580.Prio	   		:= 4;			
	xMsg9580.RiskClass		:= 4;				
	xMsg9580.Reset	   		:= FALSE;			
	xMsg9580();						
	MM2VIS.bMsg9580			:= xMsg9580.Q;			
							
	(* W9581 SAFETY - Low temperature heating water temperature 1 maximum - signal not valid *)						
	xMsg9581.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9581.Set	  		:= NOT bAMM_9581;			
	xMsg9581.PT	       		:= T#0s;			
	xMsg9581.Prio	   		:= 4;			
	xMsg9581.RiskClass		:= 4;				
	xMsg9581.Reset	   		:= FALSE;			
	xMsg9581();						
	MM2VIS.bMsg9581			:= xMsg9581.Q;			
							
	(* W9582 SAFETY - Low temperature heating water temperature 2 maximum - signal not valid *)						
	xMsg9582.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9582.Set	  		:= NOT bAMM_9582;			
	xMsg9582.PT	       		:= T#0s;			
	xMsg9582.Prio	   		:= 4;			
	xMsg9582.RiskClass		:= 4;				
	xMsg9582.Reset	   		:= FALSE;			
	xMsg9582();						
	MM2VIS.bMsg9582			:= xMsg9582.Q;			
		
	(* W9583 SAFETY - Low temperature heating water flow minimum - signal not valid *)						
	xMsg9583.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9583.Set	  		:= NOT bAMM_9583;			
	xMsg9583.PT	       		:= T#0s;			
	xMsg9583.Prio	   		:= 4;			
	xMsg9583.RiskClass		:= 4;				
	xMsg9583.Reset	   		:= FALSE;			
	xMsg9583();						
	MM2VIS.bMsg9583			:= xMsg9583.Q;			
							
	(* W9584 SAFETY - Safety loop 2 - Module control panel - signal not valid *)						
	xMsg9584.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9584.Set	  		:= NOT bAMM_9584;			
	xMsg9584.PT	       		:= T#0s;			
	xMsg9584.Prio	   		:= 4;			
	xMsg9584.RiskClass		:= 4;				
	xMsg9584.Reset	   		:= FALSE;			
	xMsg9584();						
	MM2VIS.bMsg9584			:= xMsg9584.Q;			
							
	(* W9585 SAFETY - Safety loop - Module interface panel - signal not valid *)						
	xMsg9585.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9585.Set	  		:= NOT bAMM_9585;			
	xMsg9585.PT	       		:= T#0s;			
	xMsg9585.Prio	   		:= 4;			
	xMsg9585.RiskClass		:= 4;				
	xMsg9585.Reset	   		:= FALSE;			
	xMsg9585();						
	MM2VIS.bMsg9585			:= xMsg9585.Q;			

	(* W9586 SAFETY - Exhaust gas backpressure high - signal not valid *)						
	xMsg9586.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9586.Set	  		:= NOT bAMM_9586;			
	xMsg9586.PT	       		:= T#0s;			
	xMsg9586.Prio	   		:= 4;			
	xMsg9586.RiskClass		:= 4;				
	xMsg9586.Reset	   		:= FALSE;			
	xMsg9586();						
	MM2VIS.bMsg9586			:= xMsg9586.Q;			
							
	(* W9587 SAFETY - Emergency stop signalling - output not valid *)						
	xMsg9587.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9587.Set	  		:= NOT bAMM_9587;			
	xMsg9587.PT	       		:= T#0s;			
	xMsg9587.Prio	   		:= 4;			
	xMsg9587.RiskClass		:= 4;				
	xMsg9587.Reset	   		:= FALSE;			
	xMsg9587();						
	MM2VIS.bMsg9587			:= xMsg9587.Q;			

	(* W9593 SAFETY - Nominal speed mismatch *)						
	xMsg9593.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9593.Set	  		:= NOT bAMM_9593;			
	xMsg9593.PT	       		:= T#0s;			
	xMsg9593.Prio	   		:= 4;			
	xMsg9593.RiskClass		:= 4;				
	xMsg9593.Reset	   		:= FALSE;			
	xMsg9593();						
	MM2VIS.bMsg9593			:= xMsg9593.Q;			

	(* W9597 SAFETY - Malfunction of safe communication channel - Node 300 *)						
	xMsg9597.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9597.Set	  		:= NOT bAMM_9597;			
	xMsg9597.PT	       		:= T#0s;			
	xMsg9597.Prio	   		:= 4;			
	xMsg9597.RiskClass		:= 4;				
	xMsg9597.Reset	   		:= FALSE;			
	xMsg9597();						
	MM2VIS.bMsg9597			:= xMsg9597.Q;			
							
	(* W9598 SAFETY - Malfunction of safe communication channel - Node 301 *)						
	xMsg9598.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9598.Set	  		:= NOT bAMM_9598;			
	xMsg9598.PT	       		:= T#0s;			
	xMsg9598.Prio	   		:= 4;			
	xMsg9598.RiskClass		:= 4;				
	xMsg9598.Reset	   		:= FALSE;			
	xMsg9598();						
	MM2VIS.bMsg9598			:= xMsg9598.Q;			

	(* W9600 SAFETY - Malfunction of safe communication channel - Node 105 *)						
	xMsg9600.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9600.Set	  		:= NOT bAMM_9600;			
	xMsg9600.PT	       		:= T#0s;			
	xMsg9600.Prio	   		:= 4;			
	xMsg9600.RiskClass		:= 4;				
	xMsg9600.Reset	   		:= FALSE;			
	xMsg9600();						
	MM2VIS.bMsg9600			:= xMsg9600.Q;			

	(* W9627 SAFETY - Room ventilation failure - Doors - plausibility check failure *)						
	xMsg9627.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9627.Set	  		:= NOT bAMM_9627;			
	xMsg9627.PT	       		:= T#0s;			
	xMsg9627.Prio	   		:= 4;			
	xMsg9627.RiskClass		:= 4;				
	xMsg9627.Reset	   		:= FALSE;			
	xMsg9627();						
	MM2VIS.bMsg9627			:= xMsg9627.Q;			
							
	(* W9628 SAFETY - Room ventilation failure - Doors - signal not valid *)						
	xMsg9628.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9628.Set	  		:= NOT bAMM_9628;			
	xMsg9628.PT	       		:= T#0s;			
	xMsg9628.Prio	   		:= 4;			
	xMsg9628.RiskClass		:= 4;				
	xMsg9628.Reset	   		:= FALSE;			
	xMsg9628();						
	MM2VIS.bMsg9628			:= xMsg9628.Q;			
							
	(* W9629 SAFETY - Room ventilation failure - Inlet air fan group 1 *)						
	xMsg9629.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9629.Set	  		:= NOT bAMM_9629;			
	xMsg9629.PT	       		:= T#0s;			
	xMsg9629.Prio	   		:= 4;			
	xMsg9629.RiskClass		:= 4;				
	xMsg9629.Reset	   		:= FALSE;			
	xMsg9629();						
	MM2VIS.bMsg9629			:= xMsg9629.Q;			
							
	(* W9630 SAFETY - Room ventilation failure - Inlet air fan group 1 - plausibility check failure *)						
	xMsg9630.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9630.Set	  		:= NOT bAMM_9630;			
	xMsg9630.PT	       		:= T#0s;			
	xMsg9630.Prio	   		:= 4;			
	xMsg9630.RiskClass		:= 4;				
	xMsg9630.Reset	   		:= FALSE;			
	xMsg9630();						
	MM2VIS.bMsg9630			:= xMsg9630.Q;			
							
	(* W9631 SAFETY - Room ventilation failure - Inlet air fan group 1 - signal not valid *)						
	xMsg9631.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9631.Set	  		:= NOT bAMM_9631;			
	xMsg9631.PT	       		:= T#0s;			
	xMsg9631.Prio	   		:= 4;			
	xMsg9631.RiskClass		:= 4;				
	xMsg9631.Reset	   		:= FALSE;			
	xMsg9631();						
	MM2VIS.bMsg9631			:= xMsg9631.Q;			
							
	(* W9632 SAFETY - Room ventilation failure - Inlet air fan group 2 *)						
	xMsg9632.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9632.Set	  		:= NOT bAMM_9632;			
	xMsg9632.PT	       		:= T#0s;			
	xMsg9632.Prio	   		:= 4;			
	xMsg9632.RiskClass		:= 4;				
	xMsg9632.Reset	   		:= FALSE;			
	xMsg9632();						
	MM2VIS.bMsg9632			:= xMsg9632.Q;			
							
	(* W9633 SAFETY - Room ventilation failure - Inlet air fan group 2 - plausibility check failure *)						
	xMsg9633.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9633.Set	  		:= NOT bAMM_9633;			
	xMsg9633.PT	       		:= T#0s;			
	xMsg9633.Prio	   		:= 4;			
	xMsg9633.RiskClass		:= 4;				
	xMsg9633.Reset	   		:= FALSE;			
	xMsg9633();						
	MM2VIS.bMsg9633			:= xMsg9633.Q;			
							
	(* W9634 SAFETY - Room ventilation failure - Inlet air fan group 2 - signal not valid *)						
	xMsg9634.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9634.Set	  		:= NOT bAMM_9634;			
	xMsg9634.PT	       		:= T#0s;			
	xMsg9634.Prio	   		:= 4;			
	xMsg9634.RiskClass		:= 4;				
	xMsg9634.Reset	   		:= FALSE;			
	xMsg9634();						
	MM2VIS.bMsg9634			:= xMsg9634.Q;			
							
	(* W9635 SAFETY - Room ventilation failure - Inlet air fan group 3 *)						
	xMsg9635.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9635.Set	  		:= NOT bAMM_9635;			
	xMsg9635.PT	       		:= T#0s;			
	xMsg9635.Prio	   		:= 4;			
	xMsg9635.RiskClass		:= 4;				
	xMsg9635.Reset	   		:= FALSE;			
	xMsg9635();						
	MM2VIS.bMsg9635			:= xMsg9635.Q;			
							
	(* W9636 SAFETY - Room ventilation failure - Inlet air fan group 3 - plausibility check failure *)						
	xMsg9636.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9636.Set	  		:= NOT bAMM_9636;			
	xMsg9636.PT	       		:= T#0s;			
	xMsg9636.Prio	   		:= 4;			
	xMsg9636.RiskClass		:= 4;				
	xMsg9636.Reset	   		:= FALSE;			
	xMsg9636();						
	MM2VIS.bMsg9636			:= xMsg9636.Q;			
							
	(* W9637 SAFETY - Room ventilation failure - Inlet air fan group 3 - signal not valid *)						
	xMsg9637.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9637.Set	  		:= NOT bAMM_9637;			
	xMsg9637.PT	       		:= T#0s;			
	xMsg9637.Prio	   		:= 4;			
	xMsg9637.RiskClass		:= 4;				
	xMsg9637.Reset	   		:= FALSE;			
	xMsg9637();						
	MM2VIS.bMsg9637			:= xMsg9637.Q;			
							
	(* W9638 SAFETY - Room ventilation failure - Inlet air fan group 4 *)						
	xMsg9638.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9638.Set	  		:= NOT bAMM_9638;			
	xMsg9638.PT	       		:= T#0s;			
	xMsg9638.Prio	   		:= 4;			
	xMsg9638.RiskClass		:= 4;				
	xMsg9638.Reset	   		:= FALSE;			
	xMsg9638();						
	MM2VIS.bMsg9638			:= xMsg9638.Q;			
								
	(* W9639 SAFETY - Room ventilation failure - Inlet air fan group 4 - plausibility check failure *)						
	xMsg9639.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9639.Set	  		:= NOT bAMM_9639;			
	xMsg9639.PT	       		:= T#0s;			
	xMsg9639.Prio	   		:= 4;			
	xMsg9639.RiskClass		:= 4;				
	xMsg9639.Reset	   		:= FALSE;			
	xMsg9639();						
	MM2VIS.bMsg9639			:= xMsg9639.Q;			
							
	(* W9640 SAFETY - Room ventilation failure - Inlet air fan group 4 - signal not valid *)						
	xMsg9640.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9640.Set	  		:= NOT bAMM_9640;			
	xMsg9640.PT	       		:= T#0s;			
	xMsg9640.Prio	   		:= 4;			
	xMsg9640.RiskClass		:= 4;				
	xMsg9640.Reset	   		:= FALSE;			
	xMsg9640();						
	MM2VIS.bMsg9640			:= xMsg9640.Q;			
							
	(* W9641 SAFETY - Room ventilation failure - Inlet air fan group 5 *)						
	xMsg9641.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9641.Set	  		:= NOT bAMM_9641;			
	xMsg9641.PT	       		:= T#0s;			
	xMsg9641.Prio	   		:= 4;			
	xMsg9641.RiskClass		:= 4;				
	xMsg9641.Reset	   		:= FALSE;			
	xMsg9641();						
	MM2VIS.bMsg9641			:= xMsg9641.Q;			
							
	(* W9642 SAFETY - Room ventilation failure - Inlet air fan group 5 - plausibility check failure *)						
	xMsg9642.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9642.Set	  		:= NOT bAMM_9642;			
	xMsg9642.PT	       		:= T#0s;			
	xMsg9642.Prio	   		:= 4;			
	xMsg9642.RiskClass		:= 4;				
	xMsg9642.Reset	   		:= FALSE;			
	xMsg9642();						
	MM2VIS.bMsg9642			:= xMsg9642.Q;			
							
	(* W9643 SAFETY - Room ventilation failure - Inlet air fan group 5 - signal not valid *)						
	xMsg9643.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9643.Set	  		:= NOT bAMM_9643;			
	xMsg9643.PT	       		:= T#0s;			
	xMsg9643.Prio	   		:= 4;			
	xMsg9643.RiskClass		:= 4;				
	xMsg9643.Reset	   		:= FALSE;			
	xMsg9643();						
	MM2VIS.bMsg9643			:= xMsg9643.Q;			
							
	(* W9644 SAFETY - Room ventilation failure - Inlet air fan group 6 *)						
	xMsg9644.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9644.Set	  		:= NOT bAMM_9644;			
	xMsg9644.PT	       		:= T#0s;			
	xMsg9644.Prio	   		:= 4;			
	xMsg9644.RiskClass		:= 4;				
	xMsg9644.Reset	   		:= FALSE;			
	xMsg9644();						
	MM2VIS.bMsg9644			:= xMsg9644.Q;			
		
	(* W9645 SAFETY - Room ventilation failure - Inlet air fan group 6 - plausibility check failure *)						
	xMsg9645.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9645.Set	  		:= NOT bAMM_9645;			
	xMsg9645.PT	       		:= T#0s;			
	xMsg9645.Prio	   		:= 4;			
	xMsg9645.RiskClass		:= 4;				
	xMsg9645.Reset	   		:= FALSE;			
	xMsg9645();						
	MM2VIS.bMsg9645			:= xMsg9645.Q;			
							
	(* W9646 SAFETY - Room ventilation failure - Inlet air fan group 6 - signal not valid *)						
	xMsg9646.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9646.Set	  		:= NOT bAMM_9646;			
	xMsg9646.PT	       		:= T#0s;			
	xMsg9646.Prio	   		:= 4;			
	xMsg9646.RiskClass		:= 4;				
	xMsg9646.Reset	   		:= FALSE;			
	xMsg9646();						
	MM2VIS.bMsg9646			:= xMsg9646.Q;			
							
	(* W9647 SAFETY - Room ventilation failure - Inlet air louvre group 1 - opened signal *)						
	xMsg9647.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9647.Set	  		:= NOT bAMM_9647;			
	xMsg9647.PT	       		:= T#0s;			
	xMsg9647.Prio	   		:= 4;			
	xMsg9647.RiskClass		:= 4;				
	xMsg9647.Reset	   		:= FALSE;			
	xMsg9647();						
	MM2VIS.bMsg9647			:= xMsg9647.Q;			
							
	(* W9648 SAFETY - Room ventilation failure - Inlet air louvre group 1 - closed signal *)						
	xMsg9648.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9648.Set	  		:= NOT bAMM_9648;			
	xMsg9648.PT	       		:= T#0s;			
	xMsg9648.Prio	   		:= 4;			
	xMsg9648.RiskClass		:= 4;				
	xMsg9648.Reset	   		:= FALSE;			
	xMsg9648();						
	MM2VIS.bMsg9648			:= xMsg9648.Q;			
							
	(* W9649 SAFETY - Room ventilation failure - Inlet air louvre group 1 - opened signal not valid *)						
	xMsg9649.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9649.Set	  		:= NOT bAMM_9649;			
	xMsg9649.PT	       		:= T#0s;			
	xMsg9649.Prio	   		:= 4;			
	xMsg9649.RiskClass		:= 4;				
	xMsg9649.Reset	   		:= FALSE;			
	xMsg9649();						
	MM2VIS.bMsg9649			:= xMsg9649.Q;			
							
	(* W9650 SAFETY - Room ventilation failure - Inlet air louvre group 1 - closed signal not valid *)						
	xMsg9650.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9650.Set	  		:= NOT bAMM_9650;			
	xMsg9650.PT	       		:= T#0s;			
	xMsg9650.Prio	   		:= 4;			
	xMsg9650.RiskClass		:= 4;				
	xMsg9650.Reset	   		:= FALSE;			
	xMsg9650();						
	MM2VIS.bMsg9650			:= xMsg9650.Q;			
	
	(* W9651 SAFETY - Room ventilation failure - Inlet air louvre group 1 - plausibility check failure *)						
	xMsg9651.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9651.Set	  		:= NOT bAMM_9651;			
	xMsg9651.PT	       		:= T#0s;			
	xMsg9651.Prio	   		:= 4;			
	xMsg9651.RiskClass		:= 4;				
	xMsg9651.Reset	   		:= FALSE;			
	xMsg9651();						
	MM2VIS.bMsg9651			:= xMsg9651.Q;			
							
	(* W9652 SAFETY - Room ventilation failure - Inlet air louvre group 2 - opened signal *)						
	xMsg9652.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9652.Set	  		:= NOT bAMM_9652;			
	xMsg9652.PT	       		:= T#0s;			
	xMsg9652.Prio	   		:= 4;			
	xMsg9652.RiskClass		:= 4;				
	xMsg9652.Reset	   		:= FALSE;			
	xMsg9652();						
	MM2VIS.bMsg9652			:= xMsg9652.Q;			
							
	(* W9653 SAFETY - Room ventilation failure - Inlet air louvre group 2 - closed signal *)						
	xMsg9653.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9653.Set	  		:= NOT bAMM_9653;			
	xMsg9653.PT	       		:= T#0s;			
	xMsg9653.Prio	   		:= 4;			
	xMsg9653.RiskClass		:= 4;				
	xMsg9653.Reset	   		:= FALSE;			
	xMsg9653();						
	MM2VIS.bMsg9653			:= xMsg9653.Q;			
							
	(* W9654 SAFETY - Room ventilation failure - Inlet air louvre group 2 - opened signal not valid *)						
	xMsg9654.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9654.Set	  		:= NOT bAMM_9654;			
	xMsg9654.PT	       		:= T#0s;			
	xMsg9654.Prio	   		:= 4;			
	xMsg9654.RiskClass		:= 4;				
	xMsg9654.Reset	   		:= FALSE;			
	xMsg9654();						
	MM2VIS.bMsg9654			:= xMsg9654.Q;			
							
	(* W9655 SAFETY - Room ventilation failure - Inlet air louvre group 2 - closed signal not valid *)						
	xMsg9655.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9655.Set	  		:= NOT bAMM_9655;			
	xMsg9655.PT	       		:= T#0s;			
	xMsg9655.Prio	   		:= 4;			
	xMsg9655.RiskClass		:= 4;				
	xMsg9655.Reset	   		:= FALSE;			
	xMsg9655();						
	MM2VIS.bMsg9655			:= xMsg9655.Q;			
							
	(* W9656 SAFETY - Room ventilation failure - Inlet air louvre group 2 - plausibility check failure *)						
	xMsg9656.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9656.Set	  		:= NOT bAMM_9656;			
	xMsg9656.PT	       		:= T#0s;			
	xMsg9656.Prio	   		:= 4;			
	xMsg9656.RiskClass		:= 4;				
	xMsg9656.Reset	   		:= FALSE;			
	xMsg9656();						
	MM2VIS.bMsg9656			:= xMsg9656.Q;			
	
	(* W9657 SAFETY - Room ventilation failure - Inlet air louvre group 3 - opened signal *)						
	xMsg9657.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9657.Set	  		:= NOT bAMM_9657;			
	xMsg9657.PT	       		:= T#0s;			
	xMsg9657.Prio	   		:= 4;			
	xMsg9657.RiskClass		:= 4;				
	xMsg9657.Reset	   		:= FALSE;			
	xMsg9657();						
	MM2VIS.bMsg9657			:= xMsg9657.Q;			
							
	(* W9658 SAFETY - Room ventilation failure - Inlet air louvre group 3 - closed signal *)						
	xMsg9658.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9658.Set	  		:= NOT bAMM_9658;			
	xMsg9658.PT	       		:= T#0s;			
	xMsg9658.Prio	   		:= 4;			
	xMsg9658.RiskClass		:= 4;				
	xMsg9658.Reset	   		:= FALSE;			
	xMsg9658();						
	MM2VIS.bMsg9658			:= xMsg9658.Q;			
							
	(* W9659 SAFETY - Room ventilation failure - Inlet air louvre group 3 - opened signal not valid *)						
	xMsg9659.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9659.Set	  		:= NOT bAMM_9659;			
	xMsg9659.PT	       		:= T#0s;			
	xMsg9659.Prio	   		:= 4;			
	xMsg9659.RiskClass		:= 4;				
	xMsg9659.Reset	   		:= FALSE;			
	xMsg9659();						
	MM2VIS.bMsg9659			:= xMsg9659.Q;			
							
	(* W9660 SAFETY - Room ventilation failure - Inlet air louvre group 3 - closed signal not valid *)						
	xMsg9660.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9660.Set	  		:= NOT bAMM_9660;			
	xMsg9660.PT	       		:= T#0s;			
	xMsg9660.Prio	   		:= 4;			
	xMsg9660.RiskClass		:= 4;				
	xMsg9660.Reset	   		:= FALSE;			
	xMsg9660();						
	MM2VIS.bMsg9660			:= xMsg9660.Q;			
							
	(* W9661 SAFETY - Room ventilation failure - Inlet air louvre group 3 - plausibility check failure *)						
	xMsg9661.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9661.Set	  		:= NOT bAMM_9661;			
	xMsg9661.PT	       		:= T#0s;			
	xMsg9661.Prio	   		:= 4;			
	xMsg9661.RiskClass		:= 4;				
	xMsg9661.Reset	   		:= FALSE;			
	xMsg9661();						
	MM2VIS.bMsg9661			:= xMsg9661.Q;			
							
	(* W9662 SAFETY - Room ventilation failure - Inlet air louvre group 4 - opened signal *)						
	xMsg9662.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9662.Set	  		:= NOT bAMM_9662;			
	xMsg9662.PT	       		:= T#0s;			
	xMsg9662.Prio	   		:= 4;			
	xMsg9662.RiskClass		:= 4;				
	xMsg9662.Reset	   		:= FALSE;			
	xMsg9662();						
	MM2VIS.bMsg9662			:= xMsg9662.Q;			
	
	(* W9663 SAFETY - Room ventilation failure - Inlet air louvre group 4 - closed signal *)						
	xMsg9663.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9663.Set	  		:= NOT bAMM_9663;			
	xMsg9663.PT	       		:= T#0s;			
	xMsg9663.Prio	   		:= 4;			
	xMsg9663.RiskClass		:= 4;				
	xMsg9663.Reset	   		:= FALSE;			
	xMsg9663();						
	MM2VIS.bMsg9663			:= xMsg9663.Q;			
							
	(* W9664 SAFETY - Room ventilation failure - Inlet air louvre group 4 - opened signal not valid *)						
	xMsg9664.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9664.Set	  		:= NOT bAMM_9664;			
	xMsg9664.PT	       		:= T#0s;			
	xMsg9664.Prio	   		:= 4;			
	xMsg9664.RiskClass		:= 4;				
	xMsg9664.Reset	   		:= FALSE;			
	xMsg9664();						
	MM2VIS.bMsg9664			:= xMsg9664.Q;			
							
	(* W9665 SAFETY - Room ventilation failure - Inlet air louvre group 4 - closed signal not valid *)						
	xMsg9665.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9665.Set	  		:= NOT bAMM_9665;			
	xMsg9665.PT	       		:= T#0s;			
	xMsg9665.Prio	   		:= 4;			
	xMsg9665.RiskClass		:= 4;				
	xMsg9665.Reset	   		:= FALSE;			
	xMsg9665();						
	MM2VIS.bMsg9665			:= xMsg9665.Q;			
							
	(* W9666 SAFETY - Room ventilation failure - Inlet air louvre group 4 - plausibility check failure *)						
	xMsg9666.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9666.Set	  		:= NOT bAMM_9666;			
	xMsg9666.PT	       		:= T#0s;			
	xMsg9666.Prio	   		:= 4;			
	xMsg9666.RiskClass		:= 4;				
	xMsg9666.Reset	   		:= FALSE;			
	xMsg9666();						
	MM2VIS.bMsg9666			:= xMsg9666.Q;			
							
	(* W9667 SAFETY - Room ventilation failure - Inlet air louvre group 5 - opened signal *)						
	xMsg9667.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9667.Set	  		:= NOT bAMM_9667;			
	xMsg9667.PT	       		:= T#0s;			
	xMsg9667.Prio	   		:= 4;			
	xMsg9667.RiskClass		:= 4;				
	xMsg9667.Reset	   		:= FALSE;			
	xMsg9667();						
	MM2VIS.bMsg9667			:= xMsg9667.Q;			
							
	(* W9668 SAFETY - Room ventilation failure - Inlet air louvre group 5 - closed signal *)						
	xMsg9668.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9668.Set	  		:= NOT bAMM_9668;			
	xMsg9668.PT	       		:= T#0s;			
	xMsg9668.Prio	   		:= 4;			
	xMsg9668.RiskClass		:= 4;				
	xMsg9668.Reset	   		:= FALSE;			
	xMsg9668();						
	MM2VIS.bMsg9668			:= xMsg9668.Q;			
	
	(* W9669 SAFETY - Room ventilation failure - Inlet air louvre group 5 - opened signal not valid *)						
	xMsg9669.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9669.Set	  		:= NOT bAMM_9669;			
	xMsg9669.PT	       		:= T#0s;			
	xMsg9669.Prio	   		:= 4;			
	xMsg9669.RiskClass		:= 4;				
	xMsg9669.Reset	   		:= FALSE;			
	xMsg9669();						
	MM2VIS.bMsg9669			:= xMsg9669.Q;			
							
	(* W9670 SAFETY - Room ventilation failure - Inlet air louvre group 5 - closed signal not valid *)						
	xMsg9670.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9670.Set	  		:= NOT bAMM_9670;			
	xMsg9670.PT	       		:= T#0s;			
	xMsg9670.Prio	   		:= 4;			
	xMsg9670.RiskClass		:= 4;				
	xMsg9670.Reset	   		:= FALSE;			
	xMsg9670();						
	MM2VIS.bMsg9670			:= xMsg9670.Q;			
							
	(* W9671 SAFETY - Room ventilation failure - Inlet air louvre group 5 - plausibility check failure *)						
	xMsg9671.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9671.Set	  		:= NOT bAMM_9671;			
	xMsg9671.PT	       		:= T#0s;			
	xMsg9671.Prio	   		:= 4;			
	xMsg9671.RiskClass		:= 4;				
	xMsg9671.Reset	   		:= FALSE;			
	xMsg9671();						
	MM2VIS.bMsg9671			:= xMsg9671.Q;			
							
	(* W9672 SAFETY - Room ventilation failure - Inlet air louvre group 6 - opened signal *)						
	xMsg9672.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9672.Set	  		:= NOT bAMM_9672;			
	xMsg9672.PT	       		:= T#0s;			
	xMsg9672.Prio	   		:= 4;			
	xMsg9672.RiskClass		:= 4;				
	xMsg9672.Reset	   		:= FALSE;			
	xMsg9672();						
	MM2VIS.bMsg9672			:= xMsg9672.Q;			
							
	(* W9673 SAFETY - Room ventilation failure - Inlet air louvre group 6 - closed signal *)						
	xMsg9673.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9673.Set	  		:= NOT bAMM_9673;			
	xMsg9673.PT	       		:= T#0s;			
	xMsg9673.Prio	   		:= 4;			
	xMsg9673.RiskClass		:= 4;				
	xMsg9673.Reset	   		:= FALSE;			
	xMsg9673();						
	MM2VIS.bMsg9673			:= xMsg9673.Q;			
							
	(* W9674 SAFETY - Room ventilation failure - Inlet air louvre group 6 - opened signal not valid *)						
	xMsg9674.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9674.Set	  		:= NOT bAMM_9674;			
	xMsg9674.PT	       		:= T#0s;			
	xMsg9674.Prio	   		:= 4;			
	xMsg9674.RiskClass		:= 4;				
	xMsg9674.Reset	   		:= FALSE;			
	xMsg9674();						
	MM2VIS.bMsg9674			:= xMsg9674.Q;			
	
	(* W9675 SAFETY - Room ventilation failure - Inlet air louvre group 6 - closed signal not valid *)						
	xMsg9675.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9675.Set	  		:= NOT bAMM_9675;			
	xMsg9675.PT	       		:= T#0s;			
	xMsg9675.Prio	   		:= 4;			
	xMsg9675.RiskClass		:= 4;				
	xMsg9675.Reset	   		:= FALSE;			
	xMsg9675();						
	MM2VIS.bMsg9675			:= xMsg9675.Q;			
							
	(* W9676 SAFETY - Room ventilation failure - Inlet air louvre group 6 - plausibility check failure *)						
	xMsg9676.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9676.Set	  		:= NOT bAMM_9676;			
	xMsg9676.PT	       		:= T#0s;			
	xMsg9676.Prio	   		:= 4;			
	xMsg9676.RiskClass		:= 4;				
	xMsg9676.Reset	   		:= FALSE;			
	xMsg9676();						
	MM2VIS.bMsg9676			:= xMsg9676.Q;			
							
	(* W9677 SAFETY - Room ventilation failure - Outlet air louvre group 1 - closed signal *)						
	xMsg9677.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9677.Set	  		:= NOT bAMM_9677;			
	xMsg9677.PT	       		:= T#0s;			
	xMsg9677.Prio	   		:= 4;			
	xMsg9677.RiskClass		:= 4;				
	xMsg9677.Reset	   		:= FALSE;			
	xMsg9677();						
	MM2VIS.bMsg9677			:= xMsg9677.Q;			
							
	(* W9678 SAFETY - Room ventilation failure - Outlet air louvre group 1 - opened signal not valid *)						
	xMsg9678.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9678.Set	  		:= NOT bAMM_9678;			
	xMsg9678.PT	       		:= T#0s;			
	xMsg9678.Prio	   		:= 4;			
	xMsg9678.RiskClass		:= 4;				
	xMsg9678.Reset	   		:= FALSE;			
	xMsg9678();						
	MM2VIS.bMsg9678			:= xMsg9678.Q;			
							
	(* W9679 SAFETY - Room ventilation failure - Outlet air louvre group 1 - closed signal not valid *)						
	xMsg9679.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9679.Set	  		:= NOT bAMM_9679;			
	xMsg9679.PT	       		:= T#0s;			
	xMsg9679.Prio	   		:= 4;			
	xMsg9679.RiskClass		:= 4;				
	xMsg9679.Reset	   		:= FALSE;			
	xMsg9679();						
	MM2VIS.bMsg9679			:= xMsg9679.Q;			
							
	(* W9680 SAFETY - Room ventilation failure - Outlet air louvre group 1 - plausibility check failure *)						
	xMsg9680.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9680.Set	  		:= NOT bAMM_9680;			
	xMsg9680.PT	       		:= T#0s;			
	xMsg9680.Prio	   		:= 4;			
	xMsg9680.RiskClass		:= 4;				
	xMsg9680.Reset	   		:= FALSE;			
	xMsg9680();						
	MM2VIS.bMsg9680			:= xMsg9680.Q;			
	
	(* W9681 SAFETY - Room ventilation failure - Outlet air louvre group 2 - closed signal *)						
	xMsg9681.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9681.Set	  		:= NOT bAMM_9681;			
	xMsg9681.PT	       		:= T#0s;			
	xMsg9681.Prio	   		:= 4;			
	xMsg9681.RiskClass		:= 4;				
	xMsg9681.Reset	   		:= FALSE;			
	xMsg9681();						
	MM2VIS.bMsg9681			:= xMsg9681.Q;			
							
	(* W9682 SAFETY - Room ventilation failure - Outlet air louvre group 2 - opened signal not valid *)						
	xMsg9682.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9682.Set	  		:= NOT bAMM_9682;			
	xMsg9682.PT	       		:= T#0s;			
	xMsg9682.Prio	   		:= 4;			
	xMsg9682.RiskClass		:= 4;				
	xMsg9682.Reset	   		:= FALSE;			
	xMsg9682();						
	MM2VIS.bMsg9682			:= xMsg9682.Q;			
							
	(* W9683 SAFETY - Room ventilation failure - Outlet air louvre group 2 - closed signal not valid *)						
	xMsg9683.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9683.Set	  		:= NOT bAMM_9683;			
	xMsg9683.PT	       		:= T#0s;			
	xMsg9683.Prio	   		:= 4;			
	xMsg9683.RiskClass		:= 4;				
	xMsg9683.Reset	   		:= FALSE;			
	xMsg9683();						
	MM2VIS.bMsg9683			:= xMsg9683.Q;			
							
	(* W9684 SAFETY - Room ventilation failure - Outlet air louvre group 2 - plausibility check failure *)						
	xMsg9684.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9684.Set	  		:= NOT bAMM_9684;			
	xMsg9684.PT	       		:= T#0s;			
	xMsg9684.Prio	   		:= 4;			
	xMsg9684.RiskClass		:= 4;				
	xMsg9684.Reset	   		:= FALSE;			
	xMsg9684();						
	MM2VIS.bMsg9684			:= xMsg9684.Q;			
							
	(* W9685 SAFETY - Room ventilation failure - Outlet air louvre group 3 - closed signal *)						
	xMsg9685.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9685.Set	  		:= NOT bAMM_9685;			
	xMsg9685.PT	       		:= T#0s;			
	xMsg9685.Prio	   		:= 4;			
	xMsg9685.RiskClass		:= 4;				
	xMsg9685.Reset	   		:= FALSE;			
	xMsg9685();						
	MM2VIS.bMsg9685			:= xMsg9685.Q;			
							
	(* W9686 SAFETY - Room ventilation failure - Outlet air louvre group 3 - opened signal not valid *)						
	xMsg9686.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9686.Set	  		:= NOT bAMM_9686;			
	xMsg9686.PT	       		:= T#0s;			
	xMsg9686.Prio	   		:= 4;			
	xMsg9686.RiskClass		:= 4;				
	xMsg9686.Reset	   		:= FALSE;			
	xMsg9686();						
	MM2VIS.bMsg9686			:= xMsg9686.Q;			
	
	(* W9687 SAFETY - Room ventilation failure - Outlet air louvre group 3 - closed signal not valid *)						
	xMsg9687.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9687.Set	  		:= NOT bAMM_9687;			
	xMsg9687.PT	       		:= T#0s;			
	xMsg9687.Prio	   		:= 4;			
	xMsg9687.RiskClass		:= 4;				
	xMsg9687.Reset	   		:= FALSE;			
	xMsg9687();						
	MM2VIS.bMsg9687			:= xMsg9687.Q;			
							
	(* W9688 SAFETY - Room ventilation failure - Outlet air louvre group 3 - plausibility check failure *)						
	xMsg9688.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9688.Set	  		:= NOT bAMM_9688;			
	xMsg9688.PT	       		:= T#0s;			
	xMsg9688.Prio	   		:= 4;			
	xMsg9688.RiskClass		:= 4;				
	xMsg9688.Reset	   		:= FALSE;			
	xMsg9688();						
	MM2VIS.bMsg9688			:= xMsg9688.Q;			
							
	(* W9689 SAFETY - Room ventilation failure - Outlet air louvre group 4 - closed signal *)						
	xMsg9689.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9689.Set	  		:= NOT bAMM_9689;			
	xMsg9689.PT	       		:= T#0s;			
	xMsg9689.Prio	   		:= 4;			
	xMsg9689.RiskClass		:= 4;				
	xMsg9689.Reset	   		:= FALSE;			
	xMsg9689();						
	MM2VIS.bMsg9689			:= xMsg9689.Q;			
							
	(* W9690 SAFETY - Room ventilation failure - Outlet air louvre group 4 - opened signal not valid *)						
	xMsg9690.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9690.Set	  		:= NOT bAMM_9690;			
	xMsg9690.PT	       		:= T#0s;			
	xMsg9690.Prio	   		:= 4;			
	xMsg9690.RiskClass		:= 4;				
	xMsg9690.Reset	   		:= FALSE;			
	xMsg9690();						
	MM2VIS.bMsg9690			:= xMsg9690.Q;			
							
	(* W9691 SAFETY - Room ventilation failure - Outlet air louvre group 4 - closed signal not valid *)						
	xMsg9691.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9691.Set	  		:= NOT bAMM_9691;			
	xMsg9691.PT	       		:= T#0s;			
	xMsg9691.Prio	   		:= 4;			
	xMsg9691.RiskClass		:= 4;				
	xMsg9691.Reset	   		:= FALSE;			
	xMsg9691();						
	MM2VIS.bMsg9691			:= xMsg9691.Q;			
							
	(* W9692 SAFETY - Room ventilation failure - Outlet air louvre group 4 - plausibility check failure *)						
	xMsg9692.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9692.Set	  		:= NOT bAMM_9692;			
	xMsg9692.PT	       		:= T#0s;			
	xMsg9692.Prio	   		:= 4;			
	xMsg9692.RiskClass		:= 4;				
	xMsg9692.Reset	   		:= FALSE;			
	xMsg9692();						
	MM2VIS.bMsg9692			:= xMsg9692.Q;			
	
	(* W9693 SAFETY - Room ventilation failure - Outlet air louvre group 5 - closed signal *)						
	xMsg9693.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9693.Set	  		:= NOT bAMM_9693;			
	xMsg9693.PT	       		:= T#0s;			
	xMsg9693.Prio	   		:= 4;			
	xMsg9693.RiskClass		:= 4;				
	xMsg9693.Reset	   		:= FALSE;			
	xMsg9693();						
	MM2VIS.bMsg9693			:= xMsg9693.Q;			
							
	(* W9694 SAFETY - Room ventilation failure - Outlet air louvre group 5 - opened signal not valid *)						
	xMsg9694.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9694.Set	  		:= NOT bAMM_9694;			
	xMsg9694.PT	       		:= T#0s;			
	xMsg9694.Prio	   		:= 4;			
	xMsg9694.RiskClass		:= 4;				
	xMsg9694.Reset	   		:= FALSE;			
	xMsg9694();						
	MM2VIS.bMsg9694			:= xMsg9694.Q;			
							
	(* W9695 SAFETY - Room ventilation failure - Outlet air louvre group 5 - closed signal not valid *)						
	xMsg9695.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9695.Set	  		:= NOT bAMM_9695;			
	xMsg9695.PT	       		:= T#0s;			
	xMsg9695.Prio	   		:= 4;			
	xMsg9695.RiskClass		:= 4;				
	xMsg9695.Reset	   		:= FALSE;			
	xMsg9695();						
	MM2VIS.bMsg9695			:= xMsg9695.Q;			
							
	(* W9696 SAFETY - Room ventilation failure - Outlet air louvre group 5 - plausibility check failure *)						
	xMsg9696.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9696.Set	  		:= NOT bAMM_9696;			
	xMsg9696.PT	       		:= T#0s;			
	xMsg9696.Prio	   		:= 4;			
	xMsg9696.RiskClass		:= 4;				
	xMsg9696.Reset	   		:= FALSE;			
	xMsg9696();						
	MM2VIS.bMsg9696			:= xMsg9696.Q;			
							
	(* W9697 SAFETY - Room ventilation failure - Outlet air louvre group 6 - closed signal *)						
	xMsg9697.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9697.Set	  		:= NOT bAMM_9697;			
	xMsg9697.PT	       		:= T#0s;			
	xMsg9697.Prio	   		:= 4;			
	xMsg9697.RiskClass		:= 4;				
	xMsg9697.Reset	   		:= FALSE;			
	xMsg9697();						
	MM2VIS.bMsg9697			:= xMsg9697.Q;			
							
	(* W9698 SAFETY - Room ventilation failure - Outlet air louvre group 6 - opened signal not valid *)						
	xMsg9698.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9698.Set	  		:= NOT bAMM_9698;			
	xMsg9698.PT	       		:= T#0s;			
	xMsg9698.Prio	   		:= 4;			
	xMsg9698.RiskClass		:= 4;				
	xMsg9698.Reset	   		:= FALSE;			
	xMsg9698();						
	MM2VIS.bMsg9698			:= xMsg9698.Q;			
	
	(* W9699 SAFETY - Room ventilation failure - Outlet air louvre group 6 - closed signal not valid *)						
	xMsg9699.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9699.Set	  		:= NOT bAMM_9699;			
	xMsg9699.PT	       		:= T#0s;			
	xMsg9699.Prio	   		:= 4;			
	xMsg9699.RiskClass		:= 4;				
	xMsg9699.Reset	   		:= FALSE;			
	xMsg9699();						
	MM2VIS.bMsg9699			:= xMsg9699.Q;			
							
	(* W9700 SAFETY - Room ventilation failure - Outlet air louvre group 6 - plausibility check failure *)						
	xMsg9700.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9700.Set	  		:= NOT bAMM_9700;			
	xMsg9700.PT	       		:= T#0s;			
	xMsg9700.Prio	   		:= 4;			
	xMsg9700.RiskClass		:= 4;				
	xMsg9700.Reset	   		:= FALSE;			
	xMsg9700();						
	MM2VIS.bMsg9700			:= xMsg9700.Q;			
							
	(* W9701 SAFETY - Release gas valve A for decentral gas addition - output not valid *)						
	xMsg9701.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9701.Set	  		:= NOT bAMM_9701;			
	xMsg9701.PT	       		:= T#0s;			
	xMsg9701.Prio	   		:= 4;			
	xMsg9701.RiskClass		:= 4;				
	xMsg9701.Reset	   		:= FALSE;			
	xMsg9701();						
	MM2VIS.bMsg9701			:= xMsg9701.Q;			
							
	(* W9702 SAFETY - Release gas valve B for decentral gas addition - output not valid *)						
	xMsg9702.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9702.Set	  		:= NOT bAMM_9702;			
	xMsg9702.PT	       		:= T#0s;			
	xMsg9702.Prio	   		:= 4;			
	xMsg9702.RiskClass		:= 4;				
	xMsg9702.Reset	   		:= FALSE;			
	xMsg9702();						
	MM2VIS.bMsg9702			:= xMsg9702.Q;			
							
	(* W9703 SAFETY - Gas safety device for decentral gas addition - signal not valid *)						
	xMsg9703.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9703.Set	  		:= NOT bAMM_9703;			
	xMsg9703.PT	       		:= T#0s;			
	xMsg9703.Prio	   		:= 4;			
	xMsg9703.RiskClass		:= 4;				
	xMsg9703.Reset	   		:= FALSE;			
	xMsg9703();						
	MM2VIS.bMsg9703			:= xMsg9703.Q;			
							
	(* W9704 SAFETY - Gas safety device for decentral gas addition - output not valid *)						
	xMsg9704.Enable	   		:= OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9704.Set	  		:= NOT bAMM_9704;			
	xMsg9704.PT	       		:= T#0s;			
	xMsg9704.Prio	   		:= 4;			
	xMsg9704.RiskClass		:= 4;				
	xMsg9704.Reset	   		:= FALSE;			
	xMsg9704();						
	MM2VIS.bMsg9704			:= xMsg9704.Q;			
		

	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)

	(* B2190 Emergency stop push button - module control panel (+A/+MC) *)
	xMsg2190.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2190.Set		:= IN_EG.tEmStop_MC.Di;
	xMsg2190.Reset		:= TRUE;
	xMsg2190();
	MM2VIS.bMsg2190		:= xMsg2190.Q;

	(* B2191 Emergency stop push button - module interface panel (+M) *)
	xMsg2191.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2191.Set		:= IN_EG.tEmStop_M.Di;
	xMsg2191.Reset		:= TRUE;
	xMsg2191();
	MM2VIS.bMsg2191		:= xMsg2191.Q;

	(* B2192 Emergency stop push button – master control panel (+ST) *)
	xMsg2192.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2192.Set		:= IN_EG.tEmStop_ST.Di;
	xMsg2192.Reset		:= TRUE;
	xMsg2192();
	MM2VIS.bMsg2192		:= xMsg2192.Q;

	(* B2193 Emergency stop push button – interlock panel (+IS) *)
	xMsg2193.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2193.Set		:= IN_EG.tEmStop_IS.Di;
	xMsg2193.Reset		:= TRUE;
	xMsg2193();
	MM2VIS.bMsg2193		:= xMsg2193.Q;

	(* B2194 Emergency stop push button – thermal reactor control panel (+TS) *)
	xMsg2194.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2194.Set		:= IN_EG.tEmStop_TS.Di;
	xMsg2194.Reset		:= TRUE;
	xMsg2194();
	MM2VIS.bMsg2194		:= xMsg2194.Q;

	(* B2195 Emergency stop push button – generator interface panel (+GENI) *)
	xMsg2195.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2195.Set		:= IN_EG.tEmStop_GENI.Di;
	xMsg2195.Reset		:= TRUE;
	xMsg2195();
	MM2VIS.bMsg2195		:= xMsg2195.Q;

	(* B2196 Emergency stop push button – engine interface panel bank A (+ENGIA) *)
	xMsg2196.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2196.Set		:= IN_EG.tEmStop_ENGIA.Di;
	xMsg2196.Reset		:= TRUE;
	xMsg2196();
	MM2VIS.bMsg2196		:= xMsg2196.Q;

	(* B2197 Emergency stop push button – turbocharger module interface panel (+TCMI) *)
	xMsg2197.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2197.Set		:= IN_EG.tEmStop_TCMI.Di;
	xMsg2197.Reset		:= TRUE;
	xMsg2197();
	MM2VIS.bMsg2197		:= xMsg2197.Q;

	(* B2198 Emergency stop push button – jacket water module interface panel (+JWMI) *)
	xMsg2198.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2198.Set		:= IN_EG.tEmStop_JWMI.Di;
	xMsg2198.Reset		:= TRUE;
	xMsg2198();
	MM2VIS.bMsg2198		:= xMsg2198.Q;

	(* B2199 Emergency stop push button – oil module interface panel (+OILMI) *)
	xMsg2199.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2199.Set		:= IN_EG.tEmStop_OILMI.Di;
	xMsg2199.Reset		:= TRUE;
	xMsg2199();
	MM2VIS.bMsg2199		:= xMsg2199.Q;

	(* B2200 Emergency stop push button – exhaust gas after treatment control panel (+SCR) *)
	xMsg2200.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg2200.Set		:= IN_EG.tEmStop_SCR.Di;
	xMsg2200.Reset		:= TRUE;
	xMsg2200();
	MM2VIS.bMsg2200		:= xMsg2200.Q;
	
	(* B2804 measuring signal failure main bearing temperature xx *)
	xMsg2804.Enable		:= TRUE;
	xMsg2804.Set		:= bOpM_T_MBearing_Ms;
	xMsg2804.Reset		:= TRUE;
	xMsg2804();
	MM2VIS.bMsg2804		:= xMsg2804.Q;
	
	(* B2805 main bearing temperature high *)
	xMsg2805.Enable		:= TRUE;
	xMsg2805.Set		:= bOpM_T_MBearing_Hi;
	xMsg2805.Reset		:= TRUE;
	xMsg2805();
	MM2VIS.bMsg2805		:= xMsg2805.Q;

	(* B2806 measuring signal failure conrod bearing temperature xx *)
	xMsg2806.Enable		:= TRUE;
	xMsg2806.Set		:= bOpM_T_CBearing_Ms;
	xMsg2806.Reset		:= TRUE;
	xMsg2806();
	MM2VIS.bMsg2806		:= xMsg2806.Q;

	(* B2807 conrod bearing temperature high *)
	xMsg2807.Enable		:= TRUE;
	xMsg2807.Set		:= bOpM_T_CBearing_Hi;
	xMsg2807.Reset		:= TRUE;
	xMsg2807();
	MM2VIS.bMsg2807		:= xMsg2807.Q;

	(* B2822 conrod bearing signal intensity minimum *)
	xMsg2822.Enable		:= TRUE;
	xMsg2822.Set		:= bOpM_T_CBearing_Sig_Lo;
	xMsg2822.Reset		:= TRUE;
	xMsg2822();
	MM2VIS.bMsg2822		:= xMsg2822.Q;

	(* B2904 main bearing temperature - positive MEDIAN deviation maximum *)
	xMsg2904.Enable		:= TRUE;
	xMsg2904.Set		:= bOpM_T_MBearing_MDev_HiHi;
	xMsg2904.Reset		:= TRUE;
	xMsg2904();
	MM2VIS.bMsg2904		:= xMsg2904.Q;

	(* B2905 conrod bearing temperature - positive MEDIAN deviation maximum *)
	xMsg2905.Enable		:= TRUE;
	xMsg2905.Set		:= bOpM_T_CBearing_MDev_HiHi;
	xMsg2905.Reset		:= TRUE;
	xMsg2905();
	MM2VIS.bMsg2905		:= xMsg2905.Q;

	(* B2909 Conrod bearing temperature calibration successful *)
	xTOF_Calib_Ok(IN 	:= bOpM_T_CBearing_Calib_Ok, PT := T#1s);		(* increase message time from 100ms to 1 s for HMI *)
		
	xMsg2909.Enable		:= TRUE;
	xMsg2909.Set		:= xTOF_Calib_Ok.Q;
	xMsg2909.Reset		:= TRUE;
	xMsg2909();
	MM2VIS.bMsg2909		:= xMsg2909.Q;


	(* B2958 main bearing temperature - negative MEDIAN deviation maximum *)
	xMsg2958.Enable		:= TRUE;
	xMsg2958.Set		:= bOpM_T_MBearing_MDev_Lo;
	xMsg2958.Reset		:= TRUE;
	xMsg2958();
	MM2VIS.bMsg2958		:= xMsg2958.Q;

	(* B2959 conrod bearing temperature - negative MEDIAN deviation maximum *)
	xMsg2959.Enable		:= TRUE;
	xMsg2959.Set		:= bOpM_T_CBearing_MDev_Lo;
	xMsg2959.Reset		:= TRUE;
	xMsg2959();
	MM2VIS.bMsg2959		:= xMsg2959.Q;
	
	(* B2981 PU scuffing detection *)
	xMsg2981.Enable		:= Para.bPUscf_Ena;
	xMsg2981.Set		:= bOpM_PUscuff AND bAMM_PUscuff;
	xMsg2981.Reset		:= TRUE;
	xMsg2981();
	MM2VIS.bMsg2981		:= xMsg2981.Q;

	(* B9038 Emergency stop push button – exhaust gas scavenging system control panel (+TCMSCAV) *)
	xMsg9038.Enable		:= NOT OUT_EG.bSafetyPLC_Active AND bRelModul_ParaSetupOk;			(* SAFETY PLC *)
	xMsg9038.Set		:= IN_EG.tEmStop_TCMSCAV.Di;
	xMsg9038.Reset		:= TRUE;
	xMsg9038();
	MM2VIS.bMsg9038		:= xMsg9038.Q;


	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1 	:= OUT_EG.tEG2AB.bGnlTrip1 		OR IN_EG.tAB2EG.bGnlTrip1;
	bGnlTrip2 	:= OUT_EG.tEG2AB.bGnlTrip2 		OR IN_EG.tAB2EG.bGnlTrip2;
	bGnlTrip3 	:= OUT_EG.tEG2AB.bGnlTrip3 		OR IN_EG.tAB2EG.bGnlTrip3;
	bGnlWarning := OUT_EG.tEG2AB.bGnlWarning	OR IN_EG.tAB2EG.bGnlWarning;
	bGnlTrip	:= bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	(*****************************************************************************)
END_PROGRAM
