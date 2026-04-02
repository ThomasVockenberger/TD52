(*
***************************************************************************
biogas			control/monitoring gas blower/flare  

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2025
 
Customized modifications: -
------------------------
 
History:
-------
V0.0		03.12.05/LH	erstellt
V2071		02.02.05/LH	angepasst für V2.071
 			03.03.05/LH	angepasst für neue Gasdrucküberwachungsphilosophie
V2072		16.11.05/LH	angepasst für Modulisierung 
V2201		08.08.07/LH	Vorhalte Gasverdichter vor Öffnen 1. Gasstr. während Gasumschaltung
 			12.09.07/LH	Freigabe Fackel nur wenn Gasverdichter nicht gestört ist
V2600		06.08.2009 lettenb.	task activation added
V3.10.0		15.02.2010 lettenb.	QUITT_AB, IN_GT.tAB2GT replaced by reset_alarm[x], quitt_wa
V3.20.0		17.01.2011 lettenb.	connections to alarmsXXxx added, user comment
			14.02.2011	release main gas valve FG_HGV moved to task pb8, enable alarms added
V3.99		21.09.2013	Ganguly/Denk, generated for modular software
V3.99.1		19.09.2013	Denk, V3.30.0 and V3.30.2 changes inserted
V3.99.2		25.03.2013	pankajrodey, Integration for 3.40
V4.03.00	15.03.2016	Denk, Bugfix Alarm Set for A3317
			04.04.2016	Denk, Bugfix Alarm Set for A3328 
V4.04.00	26-10-2016	Denk, Logic change for gastemperature messages 3317 and 3568
V4.07.00	19.03.2019	Zengerer, Demand compressor options for TKE Gastrain Types
V4.07.01	16.10.2019	Zengerer, Demand compressor option TOF bMEGA_GasTrain, Operating message: B2997 extended compressor demand for gas leakage check 
V4.07.02	25.10.2019	Zengerer  EDGEPOS(OUT_GT.tGT1_SafeDevice.Do) takeover from V4.07 Basisupdate
V4.09.00	16.01.2020	Zengerer  bDelayGDKG_GCStarting to delay leakage check, to allow gas compressor generate sufficient pressure, bDem_SafeDevice	(corr.Jan2020)
			06.02.2020	Zengerer  bMsg2997_Set changed, avaid  GC restart after failure reset
V4.25.00	17.12.2025	Tinello   Safety signals added



Instructions for use:
--------------------
 - activate task if used (see comment) 
 - disable gas blower if not existing 
 - RM "Fackel in Betrieb" in fb31_hb einbinden und in BILD_50 zur Anzeige bringen!

enable biogas alarms in the specific network if used:			default:

A3316	Gas compressor failure					active
W3567	Gas compressor failure					not active

A3317	Gas temperature high					active
W3568	Gas temperature high					not active
A3328 	Gas temperature measuring signal failure				not active

A3318	Gas pressure low before compressor				active
W3569	Gas pressure low before gas compressor				not active
A3327	Gas pressure before gas compressor measuring signal failure		not active
W3570	Gas pressure before gas compressor measuring signal failure		not active

A3326	Idle operation time gas compressor maximum			active

W3520	Flare failure						active


Outstandings:
------------
********************************************* 

*)

PROGRAM _CYCLIC

IF NOT Para.bBiogasActive THEN
	bDelayGDKG_GCStarting := FALSE;				(*inactive bigas compressor should not delay  bDelayGDKG_GCStarting leakage check*)
	RETURN;
ELSE

	(* Alarm Set for A3327: Measurement signal error Gas pressure before compressor *) 
	bMsg3327_Set := Para.bMsg3327Active AND NOT IN_GT.tPr_GT_Suct.GoodQual AND NOT OUT_GT.bGT2_Select;
	
	(* Alarm Set for W3570: Measurement signal error Gas pressure before compressor *) 
	bMsg3570_Set := Para.bMsg3570Active AND NOT IN_GT.tPr_GT_Suct.GoodQual AND NOT MM2VIS.bMsg3327 AND NOT bMsg3327_Set;
	
	(* Alarm Set for A3318 Gas pressure minimum before compressor *)
	xTON_FA_ZM_GDMI11.IN := MM2VIS.bMsgDummy_Min_SuctPr OR NOT IN_GT.tPr_GT_MinBefCompr.Di;
	xTON_FA_ZM_GDMI11.PT := T#2s;
	xTON_FA_ZM_GDMI11();
	HM_GDMI11    := xTON_FA_ZM_GDMI11.Q;	
	bMsg3318_Set := HM_GDMI11 AND ((FG_GDRUW AND NOT OUT_GT.bGT2_Select) OR bMsg3318_Set);
	
	(* Alarm Set for W3569 Gas pressure minimum before compressor maximum *)
	bMsg3569_Set := Para.bMsg3569Active 
		            AND HM_GDMI11 
		            AND NOT MM2VIS.bMsg3318 
		            AND NOT bMsg3318_Set           
		            AND Para.bGCActive 
		            AND (OUT_GT.bGT_TypSwhActive OR OUT_GT.bGT_TypSwhActiveHalt);		
	
	(* Alarm Set for A3328: Measurement signal from "spec_gas"*)				
	bMsg3328_Set := Para.bMsg3328Active AND NOT IN_GT.tT_GT.GoodQual AND NOT OUT_GT.bGT2_Select;
	
	(* Alarm Set for A3317 Gas temperature maximum *)
	bMsg3317_Set := ((GT_MAX AND IN_GT.tT_GT.GoodQual) OR NOT IN_GT.tT_GT_Ok.Di) AND NOT OUT_GT.bGT2_Select;    
              
	(* Alarm Set for W3568: Gas temperature maximum *)
	bMsg3568_Set := Para.bMsg3568Active AND ((GT_MAX AND IN_GT.tT_GT.GoodQual) OR NOT IN_GT.tT_GT_Ok.Di) AND NOT MM2VIS.bMsg3317 AND NOT bMsg3317_Set;     

	(* Alarm Set  for A3316: Trip: Gas compressor failure *)
	bMsg3316_Set := NOT IN_GT.tGT_GC_Fail.Di AND NOT OUT_GT.bGT2_Select;
	
	(* Alarm Set for W3567: Warning: Gas compressor failure *)
	bMsg3567_Set := Para.bMsg3567Active AND NOT IN_GT.tGT_GC_Fail.Di AND NOT MM2VIS.bMsg3316 AND NOT bMsg3316_Set;	 				
	
	(* Flare failure *)
	bMsg3520_Set := NOT IN_GT.tGT_FlairFail.Di;	

	IF (bMEGA_GasTrain) THEN					(*derived from option bit2 = '4' == MEGA Gas Train, for wide pipe dimensions with 2 separate valves 	(V4.07	Requisition- supplied code parts included for MGV) *)
		(* Demand compressor for Module operation *)
		(*-------------------------------------------------------------------------------------*)
		TOF_MEGA_GC.IN := EDGEPOS(NOT IN_GT.bSafetyPLC_Active AND bDem_SafeDevice)  						// V4.07 Basisupdate 2  old: EDGEPOS(OUT_GT.tGT1_SafeDevice.Do);(* SAFETY PLC *)	
						  OR	 (	  IN_GT.bSafetyPLC_Active AND IN_GT.tSafetyLoop_Eng.Di AND NOT IN_GT.bSafeOUT_GT1_SD_Dem_PS); 											(* SAFETY PLC *)

		IF IN_GT.tAB2GT.bGnlTrip1 OR  IN_GT.tAB2GT.bGnlTrip2 OR OUT_GT.bMsg1027 THEN 						// OR IN_GT.tAB2GT.bGnlTrip3 THEN	
			TOF_MEGA_GC.PT := 0 ;									// V4.09: avoid  GC restart after failure reset
		ELSE
			TOF_MEGA_GC.PT := IN_GT.tCU2GT.tiGT_TestDuration; 		// T#120s;	 (*time for gas compressor / Gas sfety check [s] *)
		END_IF
			
		TOF_MEGA_GC();		
		(*-------------------------------------------------------------------------------------*)	
		bDem_GC_M :=   (IN_GT.bEng_Aux_Dem OR (TOF_MEGA_GC.Q AND NOT IN_GT.tGT1_SafeDevOK.Di AND NOT IN_GT.bSafeOUT_GT1_SafeDevOK))	(*gas compressor demand extension*) 	(* SAFETY PLC *)
				AND NOT IN_GT.bMsg1053 
				AND NOT IN_GT.bMsg1054 
				AND NOT IN_GT.bMsg1031 
				AND NOT OUT_GT.bGT2_Select;

		bMsg2997_Set := Para.bGCActive 
				AND OUT_GT.tGT_GC_Dem.Do
				AND bDem_GC_M
				AND NOT IN_GT.tEng_Run.Do
				AND NOT IN_GT.bEng_Aux_Dem
				AND NOT IN_GT.tGT1_SafeDevOK.Di ;
				// := 	Para.bGCActive AND  OUT_GT.tGT_GC_Dem.Do  AND TOF_MEGA_GC.Q	; 		(* Megagas Operating message: B2997 gas compressor demand extension - gas leakage test (new in V4.09)*)

	ELSE 	
		(* Demand compressor for Module operation *)
		bDem_GC_M := IN_GT.bEng_Aux_Dem 							//OLD: gas compressor demand intermediate  ANF_V_M := 
				AND NOT IN_GT.bMsg1053
				AND NOT IN_GT.bMsg1054 
				AND NOT IN_GT.bMsg1031
				AND NOT OUT_GT.bGT2_Select;
	END_IF
	
		(* Demand Flair *)
	ANF_FA :=	IN_GT.tDemFlair.Di AND NOT IN_GT.bMsg1053 AND NOT IN_GT.bMsg1054 AND NOT IN_GT.bMsg1031 
	            AND NOT bDem_GC_M AND IN_GT.tFlairRdy.Di AND NOT MM2VIS.bMsg3520;

	(* Release  Flare (only when Gas compressure has not failed *)
	xTON_FG_FA.IN := IN_GT.tGT_GC_Fail.Di ;
	xTON_FG_FA.PT := T#5s;
	xTON_FG_FA();
	OUT_GT.tGT_RelFlair.Do := xTON_FG_FA.Q AND ANF_FA;

	(* Demand gas compressor *)	
	ANF_GVD_1				:=	ANF_FA 
	           					OR (bDem_GC_M AND (OUT_GT.tGV1_Open.Do OR V_GVD OR NOT IN_GT.tEng_Run.Do));
	OUT_GT.tGT_GC_Dem.Do 	:= FG_HGV AND ANF_GVD_1 AND NOT MM2VIS.bMsg3318 AND NOT MM2VIS.bMsg3221 AND NOT MM2VIS.bMsg3327 AND NOT MM2VIS.bMsg3326 AND NOT MM2VIS.bMsg3316;

	(* Monitoring idle operation time gas compressor maximum *)
	bMsg3326_Set := OUT_GT.tGT_GC_Dem.Do 
					AND ((NOT IN_GT.tEng_Run.Do AND bDem_GC_M) OR (OUT_GT.tGT_RelFlair.Do AND NOT IN_GT.tGT_FlareOpMod.Di));

	(* Release gas pressure monitoring (Gas pressure minimum Gas train 1 (p10_1001)) *)
	xTON_FA_GASV1.IN := OUT_GT.tGV1_Open.Do;
	xTON_FA_GASV1.PT := Para.tiGT1_Delay_Mon;			// 5s parameter introduced in V3.30
	xTON_FA_GASV1();

	xTON_FA_T_GDRUW.IN := IN_GT.bEng_Aux_Dem OR ((bDem_SafeDevice OR NOT IN_GT.bSafeOUT_GT1_SafeDevOK) AND OUT_GT.tGT_GC_Dem.Do);	(*Engine Demand OR Gas Safety Check Demand*)	(* SAFETY PLC *)
	xTON_FA_T_GDRUW.PT := Para.tiGT1_Delay_Mon;			// 5s parameter introduced in V3.30
	xTON_FA_T_GDRUW();

	T_GDRUW := (xTON_FA_GASV1.Q AND IN_GT.tEng_Run.Do) OR (xTON_FA_T_GDRUW.Q AND NOT IN_GT.tEng_Run.Do);
	
	(*generate flag to delay gas leakage checking*)
	xTOFDelayGDKG_GCStarting.IN	:= EDGEPOS(OUT_GT.tGT_GC_Dem.Do AND NOT IN_GT.tGT1_SafeDevOK.Di);  	(*bit to delay leakage check, to allow time for gas compressor building up sufficient pressure*)

	xTOFDelayGDKG_GCStarting(PT:= T#6s);
	bDelayGDKG_GCStarting 	:=xTOFDelayGDKG_GCStarting.Q ;
END_IF;

END_PROGRAM

