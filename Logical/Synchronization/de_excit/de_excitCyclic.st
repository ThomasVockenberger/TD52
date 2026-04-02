(*******************************************************************************
de-excit	 deexcitation generator

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V2.12	24.04.2006	LH			copy of gcb
								adapted for de-exitation
		11.11.2006	LH			revised for final release after Para.bMSy test
V3.90.0	09.11.2012	lettenb.	new for modulare software project
		10.05.2013				rU_Gen_Nom --> rU_Gen_Nom[1]
V4.03.0 18.11.2015 	zengerer	BUGFIX Para.rU_Gen_Nom[1] <> 0
V4.07.0 01.02.2019	hohensinner	OUT_SY.bSel_DeExc New interfaces for CU Module (AB Energy like projects and so on), no functionality change in any module done! new INPUT interfaces are not connected! new OUTPUT interfaces are connected!
		17.05.2019	lettenb.	version
V4.09.0	28.11.2019	lettenb.	gen.deexcitation with closing gas valves(before with NOT bN_EngStart), to avoid undefined generator voltage values which may cause unwanted trips of protection relays(ThJ).
V4.10.0	24.11.2019	lettenb.	bMsg2354 added
V4.12.0	14.06.2022	lettenb.	tDemGenExcOff, tGenExcOff added, dead bb synch
		23.11.2022	lettenb.	bDeEx_Dem_x: bOMSS_Man, bOMSS_Aut removed(AA46/wasserer)
								ANW_ENTR: bGnlTrip1 -> bGnlTrip(same condition as for ton_gcb_dmnd_sy)(AA46/wasserer)
V4.13.0	17.08.2023	lettenb.	dead bb synch, bugfixes(BR21/wasserer,schwab,lettenb.)
		20.11.2023	Farre,		added IN_SY.bBypassMCB_SoftStart and soft energisation demand interfaces from CU needed for Microgrid (2023-168)
		29.11.2023	Goenczi,	demand de-exc. from HMI or BUS (e.g. Aggreko)

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC
	
	IF	Para.bSyActive AND Para.bGenDeexit_Enable	THEN

		(*----------------------------------------------------------------------------*)
		(* demand de-excitation *)
		bDeEx_Dem_Man	:=	bSyOMSS_Man
					AND	NOT	gcb.man_off
					AND	   ((gcb.man_on OR ANW_ENTR)
							OR (IN_SY.bOM_Bus				(*	either from HMI or BUS *)
								AND NOT IN_SY.bSetGCB2Open				
								AND (IN_SY.bSetGCB2Close OR ANW_ENTR)));
	
		bDeEx_Dem_Aut	:=	bSyOMSS_Aut
					AND		IN_SY.bEng_Rdy_Aut_Exc;

		IF IN_SY.tDemGenExcOff.Di AND bP_Lo THEN (* dead bus synch *)
			ANW_ENTR	:= (bDeEx_Dem_Man OR bDeEx_Dem_Aut)
						OR (ANW_ENTR AND gcb.on);
		ELSE
			ANW_ENTR	:= (bDeEx_Dem_Man OR bDeEx_Dem_Aut OR IN_SY.bSoftEnergDem)
					AND	    bb_dead 
					AND     gcb.eng_oper
					AND NOT gcb.on
					AND 	gcb.rel_trip
					AND 	(IN_SY.bBypassMCB_SoftStart OR (
							NOT		mcb.on
							AND 	mcb.remote
							AND 	mcb.racked_in))
					AND	NOT	bGnlTrip
					AND	NOT	bGen_DeExc_Err;
		END_IF;

		(*----------------------------------------------------------------------------*)
		(* generator de-excited (de-energized) *)
		bGen_DeExc_Rdy	:=	ANW_ENTR AND GEN_OSP;		(* feed-back generator without voltage    *)
		
		(*----------------------------------------------------------------------------*)
		(* de-excitation finished *)
		tof_T_ENTR(IN:=	ANW_ENTR, PT:= T#5s);

		OUT_SY.bGen_Exc_Off	:=	tof_T_ENTR.Q;
	
		(*----------------------------------------------------------------------------*)
		(* de-excitation failure *)
		ton_ST_ENTR(IN:= ANW_ENTR AND NOT GEN_OSP, PT:=	T#20s);
		tof_T_ST_ENTR(IN:= ton_ST_ENTR.Q, PT:= T#26s);
	
		bGen_DeExc_Err	:=	tof_T_ST_ENTR.Q;
		OUT_SY.bGen_DeExc_Rdy := bGen_DeExc_Rdy;	
	ELSE
		ANW_ENTR		:= FALSE;
		OUT_SY.bGen_DeExc_Rdy := FALSE;
	END_IF;


	OUT_SY.bSel_DeExc	:=	ANW_ENTR;

		(*----------------------------------------------------------------------------*)
		(* Generator without voltage *)
		IF Para.rU_Gen_Nom[1] <> 0 THEN
			rU_Gen_Norm := IN_SY.tU_Avg[1].Ai / Para.rU_Gen_Nom[1];
		END_IF

		xGR_MIN_GEN_SPG(In:= rU_Gen_Norm, Gw:= Para.rU_Gen_DeEx_LimLo, Hy:= Para.rU_Gen_DeEx_LimLo/5);
		xTON_GEN_OSP(IN:= xGR_MIN_GEN_SPG.Q, PT:= T#1s);
		
		GEN_OSP := xTON_GEN_OSP.Q;
		OUT_SY.tGenExcOff.Do := GEN_OSP;

		bN_DeExc := IN_SY.rN_EngAct > (Para.rN_EngNom * 0.80);
		bDeEx_EngStop	:=	NOT bN_DeExc 	(* deexcitation at stopped engine, for unitrol reset *)
						AND NOT IN_SY.bGV_On					
						AND NOT	IN_SY.bEng_Dem;

	
		(* Generator de-excitation *)
		bGenDeexitDem := (IN_SY.bMsg1036 OR IN_SY.bMsg1073 OR IN_SY.bMsg1132 OR IN_SY.bMsg1134 OR MM2VIS.bMsg2354 OR IN_SY.bMsg3319 OR ANW_ENTR OR bDeEx_EngStop)
				      AND(NOT IN_SY.tGCB_On.Di OR IN_SY.tDemGenExcOff.Di);
		OUT_SY.tGenDeexitDem.Do := bGenDeexitDem;

		(*----------------------------------------------------------------------------*)
	
END_PROGRAM
