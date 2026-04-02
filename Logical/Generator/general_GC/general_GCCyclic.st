(*******************************************************************************
general		general functions

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2022
 
Customized modifications: -
------------------------
 
History:
-------
V4.00.0	21.01.2015	lettenb.	new
V4.00.1	28.01.2015				release gen ctr included from pb8
V4.04.0	31.10.2016				tLeroySomer_AuxContactor.Do: Para.bU_adj_gcb_ext_hilo_a OR NOT Para.bU_adj_mcb_ext_hilo_a added
								(aufschaltung 110V referenzspg. verhindern bei verstellung mit AO/wasserer rosenheim)
V4.05.0	31.10.2017				parameter check for diagnosis added
V4.11.0	26.01.2022	lettenb.	IN_GC.bU_Set_NP_Rel added for change over to AVR voltage control
V4.13.0	20.11.2023	Farre,		added IN_GC.bBypassMCB_CosPhi and request power mode interfaces from CU needed for Microgrid (2023-168)

Instructions FOR use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* check para setup *)
	IN_GC.tPB2MM.bParaSetupOk;
	Para.iEng_Motortype;    (* MIN= 208   MAX= 920    *)
	Para.rN_EngStart_LimHi; (* MIN= 50.0  MAX= 2200.0 *)
	Para.iQ_GrC_CtrlFun;    (* MIN= 0     MAX= 8      *)
	Para.rF_Nom[1]; 		(* MIN= 49    MAX= 61     *)


	(* engine typ *)
	xEngType.Motortype := INT_TO_UINT(Para.iEng_Motortype);
	xEngType();				(* use: xEngType.Type2 as BOOL, ....*)


	(* engine operation mode *)
			bOMSS_Man  := FALSE;	
			bOMSS_Aut  := FALSE;
			bOMSS_Test := FALSE;
			bOMSS_MAT  := FALSE;
			bOMSS_Scav := FALSE;
	CASE IN_GC.iIdx_OMSS OF
		1:	bOMSS_Man  := TRUE;	
			bOMSS_MAT  := TRUE;
		2:	bOMSS_Aut  := TRUE;
			bOMSS_MAT  := TRUE;
		3:	bOMSS_Test := TRUE;
			bOMSS_MAT  := TRUE;
		4:	bOMSS_Scav := TRUE;
	END_CASE;			

	(* PLC Running *) 
	IN_GC.tPB2MM.bSys_Run;

	(* Operating mode *)
	xOpMode(in := IN_GC.iSt_OpMode); 
	
	(*---------------------------------------------------------------------------*)
	(* start speed exceeded *)
	xGR_MAXR_DREHZ(In:= IN_GC.rN_EngAct, Gw:= Para.rN_EngStart_LimHi, Hy:= Para.rN_EngStart_HyHi);
	xTOF_M_DREHZ(IN:= xGR_MAXR_DREHZ.Q AND IN_GC.tPB2MM.bParaSetupOk, PT:= T#10s);
	M_DREHZ := xTOF_M_DREHZ.Q;
	
	(* ramp up speed *)
	xGR_MAXR_HDREHZ(In:= IN_GC.rN_EngAct, Gw:= Para.rN_EngStart_LimHiHi, Hy:= Para.rN_EngStart_HyHiHi);
	M_HDREHZ := xGR_MAXR_HDREHZ.Q AND IN_GC.tPB2MM.bParaSetupOk;	

	(*---------------------------------------------------------------------------*)
	(* release AVR *)
	(* UNITROL: 0= U control/island mode, 1= Q control/mains parallel mode*)
	xGR_MAXR_AN_COS(In:= IN_GC.rP_Act_Norm_Filt, Gw:= Para.rGen_CosPhi_Ena, Hy:= Para.rGen_CosPhi_Ena_Hy);
	bGen_CosPhi_Ena := xGR_MAXR_AN_COS.Q AND IN_GC.tPB2MM.bParaSetupOk;

	OUT_GC.tPF_CosPCtr_Ena.Do :=   	bGen_CosPhi_Ena
							AND NOT IN_GC.bU_Set_NP_Rel
							AND 	IN_GC.tGCB_On.Di
							AND    (IN_GC.tMCB_On.Di OR (IN_GC.bReq_PowMod AND IN_GC.bOtherGenParallel) OR IN_GC.bBypassMCB_CosPhi);

	(* release voltage selection LS-generator *)
	OUT_GC.tLeroySomer_AuxContactor.Do :=  (IN_GC.bGen_SyD_Dem AND (NOT IN_GC.tGCB_On.Di           OR NOT IN_GC.tMCB_On.Di)) 
		 								OR (IN_GC.tGCB_DVM.Di  AND (NOT Para.bU_adj_gcb_ext_hilo_a OR NOT Para.bU_adj_mcb_ext_hilo_a))
		 								OR (IN_GC.tRel_U_Sel_LS_Gen.Di AND NOT Para.bSyActive);	
	

	(* engine run + 30min *)	
	xTON_Eng_Run_30m(IN	:= IN_GC.tEng_Run.Do, PT:= T#30m);
	bEng_Run_30m 		:= xTON_Eng_Run_30m.Q;						(* engine operation for 30 minutes *)


	(* Check if actual engine speed is zero *)
	bN_EngAct_IsZero	:= ((IN_GC.rN_EngAct > -0.01) AND (IN_GC.rN_EngAct < 0.01));
			
END_PROGRAM
