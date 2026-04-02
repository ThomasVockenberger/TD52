(********************************************************************
gwt	 	Generator: winding temp.monitoring/bearing temp.monitoring 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
History:
-------

Winding temperature AND Bearing temperature
_______________________________________________________________________________________
VER	Datum/Name	Änderung
V0.1	21.10.1998	Pa			Created
 	    26.11.1998	Pa			Proofread
V180	06.03.2003	LH			VISU - Limit values active only when Recipes are on controller
 	    18.03.2003	LH			Reading the analog inputs -> pb17
V210	24.11.2004	LH			Bit to display winding temperature with measurement point 1
V2100b	15.09.2006	LH			Bit to display winding temperature with 1 measurement switched off,
				    			if 1 measurement point is with PT100 switched off.
V220	20.04.2007	LH			Bit to display Winding temperature mit 1 measurement point -> "settings" 
V2201	23.07.2007	LH			Measurement signal winding 1 - phase : Lower limit changed from -20°C to --> -50°C 
		23.07.2007	LH			Measurement signal winding 3 - phase : Lower limit changed from -20°C to --> -50°C 
														   Upper limit changed from 200°C to --> 230°C 
		23.07.2007	LH			Measurement signal bearing temperature : Lower limit changed from -20°C to --> -50°C
V4.00.1	28.01.2014	lettenb.	code cleanup
V4.05.0	14.12.2017	lettenb.	write parameter removed(code guide line)cleanup
V4.07.0	24.06.2019	lettenb.	xGR_MAXR_FA_AN_GW_TW added for SP Winding temperature warning, bugfix
														
Instructions for use: - 
--------------------
Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	IF NOT Para.bT_Gen_Wind_Ena THEN
		// 3 Phase monitoring NOT turned on, reset unused interfaces
		
		bT_Gen_Wind_L1_Max := FALSE;
		bT_Gen_Wind_L2_Max := FALSE;
		bT_Gen_Wind_L3_Max := FALSE;
		
		bT_Gen_Wind_L1_Lim := FALSE;
		bT_Gen_Wind_L2_Lim := FALSE;
		bT_Gen_Wind_L3_Lim := FALSE;
		
		(* SP Winding temperature trip *)
		xGR_MAXR_FA_AN_GW_TA(In:= IN_GC.tT_Gen_Wind.Ai, Gw:= Para.rT_Gen_Wind_Max, Hy:= Para.rT_Gen_Wind_Max_Hy2);
		xTON_FA_AN_GWTA(IN:= xGR_MAXR_FA_AN_GW_TA.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Wind_Max := xTON_FA_AN_GWTA.Q;
		
		(* SP Winding temperature warning *)	
		xGR_MAXR_FA_AN_GW_TW(In:= IN_GC.tT_Gen_Wind.Ai, Gw:= Para.rT_Gen_Wind_Lim, Hy:= Para.rT_Gen_Wind_Lim_Hy);
		xTON_FA_AN_GWTW(IN:= xGR_MAXR_FA_AN_GW_TW.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Wind_Lim := xTON_FA_AN_GWTW.Q;
			
	ELSE
		// 1-Phase Monitoring inactive
		// 3-Phase monitoring   active
		
		bT_Gen_Wind_Max := FALSE;
		bT_Gen_Wind_Lim := FALSE;	
		
		(* SP Winding 1 temperature warning *)	
		xGR_MAXR_FA_GWW1(In:= IN_GC.tT_Gen_Wind_Act_L1.Ai, Gw:= Para.rT_Gen_Wind_Lim_L1, Hy:= Para.rT_Gen_Wind_Lim_Hy2);
		xTON_FA_AN_GWW1(IN:= xGR_MAXR_FA_GWW1.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Wind_L1_Lim := xTON_FA_AN_GWW1.Q;
		
		(* SP Winding 2 temperature warning *)	
		xGR_MAXR_FA_GWW2(In:= IN_GC.tT_Gen_Wind_Act_L2.Ai, Gw:= Para.rT_Gen_Wind_Lim_L2, Hy:= Para.rT_Gen_Wind_Lim_Hy2);
		xTON_FA_AN_GWW2(IN:= xGR_MAXR_FA_GWW2.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Wind_L2_Lim := xTON_FA_AN_GWW2.Q;
		
		(* SP Winding 3 temperature warning *)	
		xGR_MAXR_FA_GWW3(In:= IN_GC.tT_Gen_Wind_Act_L3.Ai, Gw:= Para.rT_Gen_Wind_Lim_L3, Hy:= Para.rT_Gen_Wind_Lim_Hy2);
		xTON_FA_AN_GWW3(IN:= xGR_MAXR_FA_GWW3.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#3s);
		bT_Gen_Wind_L3_Lim := xTON_FA_AN_GWW3.Q;	

		(* SP Winding 1 temperature trip *)
		xGR_MAXR_FA_GWA1(In:= IN_GC.tT_Gen_Wind_Act_L1.Ai, Gw:= Para.rT_Gen_Wind_Max_L1, Hy:= Para.rT_Gen_Wind_Max_Hy);
		xTON_FA_T_AN_GWA1(IN:= xGR_MAXR_FA_GWA1.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Wind_L1_Max := xTON_FA_T_AN_GWA1.Q;
		
		(* SP Winding 2 temperature trip *)
		xGR_MAXR_FA_GWA2(In:= IN_GC.tT_Gen_Wind_Act_L2.Ai, Gw:= Para.rT_Gen_Wind_Max_L2, Hy:= Para.rT_Gen_Wind_Max_Hy);
		xTON_FA_T_AN_GWA2(IN:= xGR_MAXR_FA_GWA2.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Wind_L2_Max := xTON_FA_T_AN_GWA2.Q;
		
		(* SP Winding 3 temperature trip *)
		xGR_MAXR_FA_GWA3(In:= IN_GC.tT_Gen_Wind_Act_L3.Ai, Gw:= Para.rT_Gen_Wind_Max_L3, Hy:= Para.rT_Gen_Wind_Max_Hy);
		xTON_FA_T_AN_GWA3(IN:= xGR_MAXR_FA_GWA3.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#3s);
		bT_Gen_Wind_L3_Max := xTON_FA_T_AN_GWA3.Q;
			
	END_IF;

(*
   There can be total of two bearing temperature monitors. 
   Based on the Para.bT_Gen_Bear_A_Ena and Para.bT_Gen_Bear_B_Ena parameters it is possible to monitor
	 1. One of the bearing temperature 
 	 2. Both bearing temperatures
	 3. None of the bearing temperatures (if not required eg. low KW engines)
*)

	(* Bearing1 temperature monitoring *)
	IF NOT Para.bT_Gen_Bear_A_Ena THEN 	(* Bearing temperature monitoring inactive *)
		bT_Gen_Bear_A_Max := FALSE;
		bT_Gen_Bear_A_Lim := FALSE;		
	ELSE								(* Bearing temperature monitoring active *)
		(* Bearing 1 Temperature maximum Warning *)
		xGR_MAXR_FA_AN_LAGW1(In:= IN_GC.tT_Gen_Bear_A_Act.Ai, Gw:= Para.rT_Gen_Bear_Lim_A, Hy:= Para.rT_Gen_Bear_Max_Hy_A);
		xTON_FA_T_AN_LAGW1(IN:= xGR_MAXR_FA_AN_LAGW1.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Bear_A_Lim := xTON_FA_T_AN_LAGW1.Q;

		(* Bearing 1 Temperature maximum Trip*)
		xGR_MAXR_FA_AN_LAGA1(In:= IN_GC.tT_Gen_Bear_A_Act.Ai, Gw:= Para.rT_Gen_Bear_Max_A, Hy:= Para.rT_Gen_Bear_Max_Hy_A);
		xTON_FA_T_AN_LAGA1(IN:= xGR_MAXR_FA_AN_LAGA1.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Bear_A_Max := xTON_FA_T_AN_LAGA1.Q;	
	END_IF;


	(* Bearing2 temperature monitoring *)
	IF NOT Para.bT_Gen_Bear_B_Ena THEN	(* Bearing temperature monitoring inactive	*)
		bT_Gen_Bear_B_Max := FALSE;	
		bT_Gen_Bear_B_Lim := FALSE;
	ELSE								(* Bearing temperature monitoring active *)
		(* SP Bearing 2 Temperature maximum Warning *)
		xGR_MAXR_FA_AN_LAGW2(In:= IN_GC.tT_Gen_Bear_B_Act.Ai, Gw:= Para.rT_Gen_Bear_Lim_B, Hy:= Para.rT_Gen_Bear_Max_Hy_B);    
		xTON_FA_T_AN_LAGW2(IN:= xGR_MAXR_FA_AN_LAGW2.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Bear_B_Lim := xTON_FA_T_AN_LAGW2.Q;
		
		(* SP Bearing 2 Temperature maximum Trip*)
		xGR_MAXR_FA_AN_LAGA2(In:= IN_GC.tT_Gen_Bear_B_Act.Ai, Gw:= Para.rT_Gen_Bear_Max_B, Hy:= Para.rT_Gen_Bear_Max_Hy_B);	
		xTON_FA_T_AN_LAGA2(IN:= xGR_MAXR_FA_AN_LAGA2.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#2s);
		bT_Gen_Bear_B_Max := xTON_FA_T_AN_LAGA2.Q;
	END_IF;

END_PROGRAM    




