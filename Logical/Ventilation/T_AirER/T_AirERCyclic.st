(*******************************************************************************
T_AirER			temperature air engine room 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V190	12.08.2004	LH			erstellt
V220	01.03.2007	LH			Erweiterung auf Pt100
 		10.04.2007	LH			Korrektur Messignalüberwachung, Zuweisung für Pt100 
V2201	23.07.2007	LH			Messignalüberwachung: UGR -20°C --> -50°C
V3.99.0	14.02.2013	lettenb.	task rtm renamed to T_AirER
V4.14.0 10.12.2024	Nagy		engine room temp high warning added
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	IF IN_VE.tT_AirER.GoodQual THEN
		rT_AirER := IN_VE.tT_AirER.Ai;			(* standard sensor       engine room temperature *)
	ELSE 	
		rT_AirER := IN_VE.rT_AirER_Customized;	(* customized preparated engine room temperature *)	
	END_IF;

	(* engine room temperature limit warning *)	
	xGRMAXR_Hi_Wr(Gw:= Para.rT_AirER_LimWr, Hy:= Para.rT_AirER_HyHi, In:= rT_AirER);
	bT_AirER_Hi_Wr := IN_VE.tPB2MM.bParaSetupOk AND xGRMAXR_Hi_Wr.Q AND Para.bT_AirER_Active;

	(*---------------------------------------------------------------------------*)
	(* engine room temperature limit high *)	
	xGRMAXR_Hi(Gw:= Para.rT_AirER_LimHi, Hy:= Para.rT_AirER_HyHi, In:= rT_AirER);
	bT_AirER_Hi := IN_VE.tPB2MM.bParaSetupOk AND xGRMAXR_Hi.Q AND Para.bT_AirER_Active;
	
	(*---------------------------------------------------------------------------*)
	(* engine room temperature limit 1 (start ventilation(stage 1)) *)
	xGRMAXR_Hi1(Gw:= Para.rT_AirER_LimHi1, Hy:= Para.rT_AirER_HyHi1, In:= rT_AirER);
	bT_AirER_Hi1 := IN_VE.tPB2MM.bParaSetupOk AND xGRMAXR_Hi1.Q AND Para.bT_AirER_Active;
	
	(*---------------------------------------------------------------------------*)
	(* engine room temperature limit 2 (start ventilation stage 2) *)
	xGRMAXR_Hi2(Gw:= Para.rT_AirER_LimHi2, Hy:= Para.rT_AirER_HyHi2, In:= rT_AirER);
	bT_AirER_Hi2 := IN_VE.tPB2MM.bParaSetupOk AND xGRMAXR_Hi2.Q AND Para.bT_AirER_Active;	
	
	(*---------------------------------------------------------------------------*)
	(* engine room temperature limit 3 (reserve limit value) *)
	xGRMAXR_Hi3(Gw:= Para.rT_AirER_LimHi3, Hy:= Para.rT_AirER_HyHi3, In:= rT_AirER);
	bT_AirER_Hi3 := IN_VE.tPB2MM.bParaSetupOk AND xGRMAXR_Hi3.Q AND Para.bT_AirER_Active;	
	
	(*---------------------------------------------------------------------------*)
	(* engine room temperature limit 4 (start ventilation at engine stop) *)		
	xGRMAXR_Hi4(Gw:= Para.rT_AirER_LimHi4, Hy:= Para.rT_AirER_HyHi4, In:= rT_AirER);
	bT_AirER_Hi4  := IN_VE.tPB2MM.bParaSetupOk AND xGRMAXR_Hi4.Q AND Para.bT_AirER_Active;	


END_PROGRAM

