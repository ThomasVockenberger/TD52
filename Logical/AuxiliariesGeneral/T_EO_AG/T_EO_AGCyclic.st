(*******************************************************************************
T_EO	engine oil temperature

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: 
------------------------- 
-

History:
--------
V0.1	02.10.1998	Pa			erstellt
		26.11.1998	Pa			korrekturlesung
V1.70	04.04.2002	LH			Verzögerung Öltemperatur max. => 5min
								Grenzwert Öltemperatur max. + 4/5°C (Abstellung)
V1.80	06.02.2003	LH			Grenzwert Öltemperatur max. + 4°C --> + 2°C (BR 2/3/4)
		06.03.2003	LH			VISU-Grenzwerte erst aktiv wenn Rezepte auf Steuerung sind
		18.03.2003	LH			Einlesen Analogeingang --> pb17
V3.20.0	12.05.2010	lettenb.	OT_LFG added for BR9
		01.07.2010 				Öltemperatur maximum: BR9_B added
V3.90.0	06.12.2011	Ganguly		generated from otpCyclic.st V3.20
		08.03.2012	Denk		review and clean-up
V3.99.0	04.04.2013	lettenb.	INIT removed (no write to parameter allowed)
		28.05.2013	lettenb.	bTestEnabled Para -> loc.var
		29.07.2013				engine oil temp.high monitoring moved to MsgAG
V4.06.0	29.08.2018	Perktold	added fast start release from oil temperature

Instructions for use:
--------------------
Outstandings:
------------
********************************************************************)

PROGRAM _CYCLIC
	
	(* load release from oil temperature *)
	xGR_MAXR_OT_LFG(In:= IN_AG.tT_EO.Ai, Gw:= Para.rT_EOP_LimRelLoad, Hy:= Para.rT_EOP_HyRelLoad);
	xTON_OT_LFG(IN:= IN_AG.tPB2MM.bParaSetupOk AND xGR_MAXR_OT_LFG.Q, PT:= T#2s);
	OUT_AG.bT_EOP_RelLoad := xTON_OT_LFG.Q;

	(* fast start release from oil temperature *)
	xGR_MAXR_OT_FS(In:= IN_AG.tT_EO.Ai, Gw:= 27.0, Hy:= 1.0);
	xTON_OT_FS(IN:= IN_AG.tPB2MM.bParaSetupOk AND xGR_MAXR_OT_FS.Q, PT:= T#2s);
	OUT_AG.bT_EOP_RelFS := xTON_OT_FS.Q;
	
	(*-------------------------------------------------------------------------------*)
	(* power reduction according high oil temperature *)
	OUT_AG.rP_Red_T_Oil_Norm := LIMIT(0.5, (1 - ((IN_AG.tT_EO.Ai - Para.rP_Red_T_Oil_Start) * Para.rP_Red_T_Oil_Rate)), 1.0);
	
	
END_PROGRAM
