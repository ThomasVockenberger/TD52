(*******************************************************************************
barometric		barometric pressure  					(CYCLIC)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2021
 
Customized modifications: -
------------------------
 
History:
-------
V04.02.00.00	28.01.2015  Tinello		NEW specification
V04.04.00.00	22.06.2015	Tinello		Limitierung eingefügt
				20.10.2016	Tinello		Limitierung angepasst -> Spezi (c)
V04.05.00.00	22.01.2018	Tinello		Out-Schnittstelle für Ms-Störung hinzu
V04.10.00.00	28.01.2021	Tinello  	BugFix: Timer & other FuB's

Instructions FOR use:
--------------------
*******************************************************************************)
PROGRAM _CYCLIC

	(*--------------------------------------------------------------*)	
	(* RESET of alarms and warnings and pre-settings				*)
	(*--------------------------------------------------------------*)
	bAMM_Pr_Baro_Ms				:= FALSE;
	bAMM_Pr_Baro_siteDev_Lo		:= FALSE; 
	bAMM_Pr_Baro_siteDev_Hi		:= FALSE;

	OUT_EG.rPr_Baro_Internal	:= 0;


	(*--------------------------------------------------------------*)	
	(* VISU var of module 											*)
	(*--------------------------------------------------------------*)	
	MM2VIS.rPr_Baro				:= IN_EG.tPr_Baro.Ai;



	(************************************************************************************************************************************)
	(************************              				  error monitoring		 	             	           **************************)
	(************************************************************************************************************************************)
	xGR_MINR_Baro(In:= IN_EG.tPr_Baro.Ai, Gw:= (Para.rPr_Baro_site - Para.rPr_Baro_siteDevMax), Hy:= 0.01); (* hyst. = 10 mbar *)		
	xGR_MAXR_Baro(In:= IN_EG.tPr_Baro.Ai, Gw:= (Para.rPr_Baro_site + Para.rPr_Baro_siteDevMax), Hy:= 0.01);	(* hyst. = 10 mbar *)		

	IF bRelModul_ParaSetupOk THEN

		(*----------------------------------------------------------*)	
		(* measurement signal failure 								*)
		(*----------------------------------------------------------*)	
		bAMM_Pr_Baro_Ms	 		:= Para.bPr_Baro_Exist 	AND NOT IN_EG.tPr_Baro.GoodQual;										(* W3449 *)	

			(* Release monitoring *)
			xTOF_AMM_Pr_Baro(IN := bAMM_Pr_Baro_Ms, PT:= T#10s);					(* TOF because of filtered signals *)	

			bRelMon_Pr_Baro		:= Para.bPr_Baro_Exist  AND NOT xTOF_AMM_Pr_Baro.Q;


		(*----------------------------------------------------------*)	
		(* barometric pressure										*)
		(*----------------------------------------------------------*)	
		bAMM_Pr_Baro_siteDev_Lo	:= xGR_MINR_Baro.Q AND bRelMon_Pr_Baro;															(* W2552 *)
		bAMM_Pr_Baro_siteDev_Hi	:= xGR_MAXR_Baro.Q AND bRelMon_Pr_Baro;															(* W2553 *)


		(* switch barometric pressure in case of error *)
		IF 	NOT bRelMon_Pr_Baro 	OR												(* sensor not active or measuring signal error *)		 
			bAMM_Pr_Baro_siteDev_Lo OR 												(* signal out of plausible range *)
			bAMM_Pr_Baro_siteDev_Hi								
		THEN	
			xRAMPE_R_Pr_Baro.In	:= Para.rPr_Baro_site;								(* use parameter for calculation *)
		ELSE
			xRAMPE_R_Pr_Baro.In	:= IN_EG.tPr_Baro.Ai;
		END_IF

		xRAMPE_R_Pr_Baro(enable	:= TRUE);	

		OUT_EG.rPr_Baro_Internal		:= LIMIT(0.8, xRAMPE_R_Pr_Baro.Out, 1.050);	(* ramp with 10 mbar/s *)
		OUT_EG.bAMM_Pr_Baro_Internal	:= NOT bRelMon_Pr_Baro;
	ELSE
		xTOF_AMM_Pr_Baro(IN 			:= FALSE);
		xRAMPE_R_Pr_Baro(enable			:= FALSE);	
	END_IF

END_PROGRAM
