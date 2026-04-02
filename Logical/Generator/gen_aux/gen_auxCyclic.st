(*******************************************************************************
gen_aux		generator auxiliaries

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V3.40.0	22.11.2011	lettenb.	new
V3.99.9 13.02.2014  ganguly     modified Generator preheating condition changed because
								Generator PTC monitoring -> Standstill heating OF generator
								does not shut off.
V4.01.0 19.05.2014	Denk		Generator preheating condition changed IN_GC.tECW_PreH_Dem.Do;	
V4.01.1	12.02.2014	lettenb.	Genoheizung von Vorwärmpumpe trennen, Vorwärmpumpe wird auch für hydraulische 
								Vorwärmung und/oder für Abkühlprogramm verwendet (920 stapelfeld)
V4.04.0	18.05.2016	lettenb.	DO_GEN_BERC added from ex task gen_lub: demand lubeoil cooling system, bugfix 
V4.05.0 30.03.2017	lettenb.	xGR_MAX_GenPreH.Gw: - 0.5, Hy:= 0.5 =>  - 5.0, Hy:= 5.0, bugfix
V4.07.0	29.04.2019	lettenb.	1054 fire alarm added(separation from safety loop(1031) with safety PLC)
		30.07.2019	lettenb.	LOS_Dem.Do: 1054,1031 added(safety request, doujak andreas) bu01
V4.11.0	05.11.2021	Schmid		Generator preheating independent of electric or hydraulic ECW preheating
		18.01.2022	lettenb.	generator bearing lubrication(Aerotherm) demand for bN2_ScavCoPrelubeOn OR IN_GC.bEO_PrelubeDemIgn, bugfix
										
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)

PROGRAM _CYCLIC

	(*------------------------------------------------------------------------------------*)
	(* generator preheating *)
	xGR_MAX_GenPreH(In:= IN_GC.tT_Gen_Bear_B_Act.Ai, Gw:= Para.rT_Gen_Bear_Lim_B - 5.0, Hy:= 5.0);	(* NDE bearing temperature *)
	xTON_MAX_GenPreH(IN:= xGR_MAX_GenPreH.Q, PT:= T#2s);

	IF xEngType.Type9 THEN 				OUT_GC.tGen_PreHDem.Do := bOMSS_MAT AND NOT IN_GC.bEng_Aux_Dem_CDR AND NOT IN_GC.bMsg1031 AND NOT IN_GC.bMsg1054 AND NOT xTON_MAX_GenPreH.Q;
	ELSIF Para.bT_Gen_Bear_B_Ena THEN	OUT_GC.tGen_PreHDem.Do := IN_GC.tECWP_PreH_Dem.Do AND NOT xTON_MAX_GenPreH.Q;
	ELSE								OUT_GC.tGen_PreHDem.Do := IN_GC.bECW_Gnl_PreH_Dem;
	END_IF;	


	(*------------------------------------------------------------------------------------*)
	(* generator: demand (aerotherm) lubeoil/cooling system LSA56, TD125, WD130 (not 920) *)
    OUT_GC.tLOS_Dem.Do := (IN_GC.bEng_Aux_Dem OR M_DREHZ OR IN_GC.bN2_ScavCoPrelubeOn OR IN_GC.bEO_PrelubeDemIgn)
				   AND NOT IN_GC.bMsg1031
				   AND NOT IN_GC.bMsg1054;


END_PROGRAM
