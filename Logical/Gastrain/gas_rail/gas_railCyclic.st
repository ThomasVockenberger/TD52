(*******************************************************************************
gas_rail	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V04.03.00	20.01.2015  Denk 		Porting J920 for XT4
			07.04.2016  Denk		Change logic for A2240 ("...ja, lass es uns so machen, dass es eine Freigabebedingung gibt. 2240 soll nur auslösen, wenn es keine Messsignalstörung 2567 gibt..." E-mail 07.04.2016 Klaus Spyra) 
V04.04.00	04.07.2016	Denk		Change logic for bAMM_T_GR_HiHi. Additional: AND OUT_GT.tGV1_Open.Do;
V04.05.00	20.03.2017	Denk		SWAT920: Several changes regarding new specification
V04.05.01	24.10.2017	Zingerle	Reduction with difference pressure minimum, implemented
V04.05.02	01.03.2018	Denk		Reduction with difference pressure minimum, Spec. change and validation changes
V04.05.03	23.03.2018	Denk		Perm2 change because of new Perm_GT2 file
V04.07.00	04.07.2018	Denk		Bugfix, Anzeige Leistungsreduktion Gasdruck min.
V04.10.00	05.08.2020	Zuschnig	Included 50ms filtered for boost pressure for differential pressure limit monitoring
V04.11.00	20.01.2022	Zuschnig	Update gas rail pressure power reduction

Instructions for use:
--------------------
*******************************************************************************)
PROGRAM _CYCLIC

	(*--------------------------------------------------------------*)	
	(* RESET of alarms and warnings 								*)
	(*--------------------------------------------------------------*)	
	bAMM_Pr_GR_I_MS			:= FALSE; 
	bAMM_Pr_GR_II_MS		:= FALSE; 
	bAMM_Pr_GR_I_LoLo		:= FALSE;
	bAMM_Pr_GR_I_HiHi		:= FALSE;
	bAMM_DPr_GR_I_LoLo		:= FALSE;
	bAMM_DPr_GR_I_HiHi		:= FALSE;
	bAMM_DPr_GR_I_Lo		:= FALSE;
	bAMM_DPr_GR_I_Hi		:= FALSE;
	bAMM_T_GR_MS			:= FALSE;
	bAMM_T_GR_LoLo			:= FALSE;
	bAMM_T_GR_HiHi			:= FALSE;
	bAMM_T_GR_Lo			:= FALSE;
	bAMM_T_GR_Hi			:= FALSE;
	bAMM_Pr_MGT_a_Filt_Min	:= FALSE;

	rP_norm_red_1				:= 1.0;
	rP_norm_red_2				:= 1.0;	
	OUT_GT.rP_Red_Pr_GR_Norm	:= 1.0;
	
	
	(************************************************************************************************************************************)
	(************************              				  error monitoring		 	             	           **************************)
	(************************************************************************************************************************************)
	IF IN_GT.tPB2MM.bParaSetupOk THEN
	
		(*----------------------------------------------------------*)	
		(* measurement signal failure 								*)
		(*----------------------------------------------------------*)	
		bAMM_Pr_GR_I_MS		:= Para.bPr_GR_I_Exist 	AND NOT IN_GT.tPr_GR_I.GoodQual;		(* W2443 *)
		bAMM_Pr_GR_II_MS	:= Para.bPr_GR_II_Exist	AND NOT IN_GT.tPr_GR_II.GoodQual;		(* W2444 *) 
		bAMM_Pr_GR_I_II_MS  := bAMM_Pr_GR_I_MS 		AND 	bAMM_Pr_GR_II_MS; 				(* A2309 *) 
		bAMM_T_GR_MS		:= Para.bT_GR_Exist 	AND NOT IN_GT.tT_GR.GoodQual;			(* W2567 *)

		(* Release monitoring	*)
		xTOF_AMM_Pr_GR_I_MS(IN 	:= bAMM_Pr_GR_I_MS,	 PT:= T#10s);	(* TOF because of filtered signals *)	
		xTOF_AMM_Pr_GR_II_MS(IN	:= bAMM_Pr_GR_II_MS, PT:= T#10s);
		xTOF_AMM_T_GR_MS(IN  	:= bAMM_T_GR_MS, 	 PT:= T#10s);

		bRelMon_Pr_GR_I		:= Para.bPr_GR_I_Exist 	AND NOT xTOF_AMM_Pr_GR_I_MS.Q;
		bRelMon_Pr_GR_II	:= Para.bPr_GR_II_Exist AND NOT xTOF_AMM_Pr_GR_II_MS.Q;
		bRelMon_Pr_GR_Avg	:= bRelMon_Pr_GR_I 		OR 		bRelMon_Pr_GR_II; 
		bRelMon_T_GR		:= Para.bT_GR_Exist 	AND NOT xTOF_AMM_T_GR_MS.Q;


		(*----------------------------------------------------------*)	
		(* check gas rail pressure sensor deviation					*)
		(*----------------------------------------------------------*)	
		LCRMAF_PGR_Deviation.x := ABS(IN_GT.tPr_GR_I.Ai - IN_GT.tPr_GR_II.Ai);

		LCRMAF_PGR_Deviation();
	
		xGR_MAX_Deviation.In := LCRMAF_PGR_Deviation.y;
		xGR_MAX_Deviation.Gw := 0.130;	(* 130mbar *)		
		xGR_MAX_Deviation.Hy := 0.03; 	(* 30mbar *)		
		xGR_MAX_Deviation();

		bDevP_GR_TooHigh := xGR_MAX_Deviation.Q AND bRelMon_Pr_GR_I AND bRelMon_Pr_GR_II;		


		(*----------------------------------------------------------*)	
		(* gas rail pressure limit monitoring						*)
		(*----------------------------------------------------------*)
		xGR_MAX_AGRPR(In := IN_GT.tPr_GR_I.Ai, Gw := Para.rPr_GR_HiHi, Hy := 0.0);	

		bAMM_Pr_GR_I_HiHi 	:= xGR_MAX_AGRPR.Q AND bRelMon_Pr_GR_I;		(* A2244 *)			

		
		(*----------------------------------------------------------*)	
		(* differential pressure limit monitoring					*)
		(*----------------------------------------------------------*)
		xGR_MAX_APDPR(In := (rPr_GR_Avg - xFILTER_R_P2s_50ms.Out), Gw := Para.rPr_GR_Diff_HiHi, Hy := 0.0);	
		xGR_MIN_APDPR(In := (rPr_GR_Avg - xFILTER_R_P2s_50ms.Out), Gw := Para.rPr_GR_Diff_LoLo, Hy := 0.0);

		bAMM_DPr_GR_I_HiHi	:= xGR_MAX_APDPR.Q AND OUT_GT.tGV1_Open.Do;	(* A2248 *)				
		bAMM_DPr_GR_I_LoLo	:= xGR_MIN_APDPR.Q AND IN_GT.tGCB_On.Di ;	(* A2249 *)				  

	
		(*----------------------------------------------------------*)	
		(* gas rail temperature limit monitoring					*)
		(*----------------------------------------------------------*)
		xGR_MAX_WGRTP(In := IN_GT.tT_GR.Ai, Gw := (Para.rT_GR_HiHi - 5.0), Hy := 0.0);	
		xGR_MIN_WGRTP(In := IN_GT.tT_GR.Ai, Gw := (Para.rT_GR_LoLo), Hy := 0.0);

		bAMM_T_GR_Hi	:= xGR_MAX_WGRTP.Q AND bRelMon_T_GR AND OUT_GT.tGV1_Open.Do;			(* W2568 *)		
		bAMM_T_GR_Lo	:= xGR_MIN_WGRTP.Q AND bRelMon_T_GR AND OUT_GT.tGV1_Open.Do;			(* W2569 *)

		xGR_MAX_AGRTP(In := IN_GT.tT_GR.Ai, Gw := Para.rT_GR_HiHi, Hy := 0.0);	

		bAMM_T_GR_HiHi	:= xGR_MAX_AGRTP.Q AND bRelMon_T_GR AND OUT_GT.tGV1_Open.Do;			(* A2240 *)		


		(*----------------------------------------------------------*)	
		(* gas rail pressure average filtered						*)
		(*----------------------------------------------------------*)
		IF 	  (NOT bRelMon_Pr_GR_I AND NOT bRelMon_Pr_GR_II) THEN	rPr_GR_Avg :=  0;
		ELSIF (NOT bRelMon_Pr_GR_I AND 	   bRelMon_Pr_GR_II) THEN	rPr_GR_Avg :=  IN_GT.tPr_GR_II.Ai;
		ELSIF (	   bRelMon_Pr_GR_I AND NOT bRelMon_Pr_GR_II) THEN	rPr_GR_Avg :=  IN_GT.tPr_GR_I.Ai;
		ELSE	
			IF NOT bDevP_GR_TooHigh  THEN 
				rPr_GR_Avg := (IN_GT.tPr_GR_I.Ai + IN_GT.tPr_GR_II.Ai ) / 2;
			ELSE  
				IF  ABS(IN_GT.tPr_GR_I.Ai - (rPr_MGT_sp + IN_GT.rPr_Baro_Internal)) <  ABS(IN_GT.tPr_GR_II.Ai - (rPr_MGT_sp + IN_GT.rPr_Baro_Internal))  THEN
			 		rPr_GR_Avg := IN_GT.tPr_GR_I.Ai;
				ELSE
					rPr_GR_Avg := IN_GT.tPr_GR_II.Ai;
				END_IF;
			END_IF;		
		END_IF;
		OUT_GT.rPr_GR_filt := rPr_GR_Avg;	

		(*----------------------------------------------------------*)	
		(* gas rail pressure average unfiltered						*)
		(*----------------------------------------------------------*)
		IF 	  (NOT bRelMon_Pr_GR_I AND NOT bRelMon_Pr_GR_II) THEN	rPr_GR_Avg_UF :=  0;
		ELSIF (NOT bRelMon_Pr_GR_I AND 	   bRelMon_Pr_GR_II) THEN	rPr_GR_Avg_UF :=  IN_GT.tPr_GR_II.Unfilt;
		ELSIF (	   bRelMon_Pr_GR_I AND NOT bRelMon_Pr_GR_II) THEN	rPr_GR_Avg_UF :=  IN_GT.tPr_GR_I.Unfilt;
		ELSE	
			IF NOT bDevP_GR_TooHigh  THEN 			
				rPr_GR_Avg_UF := (IN_GT.tPr_GR_I.Unfilt + IN_GT.tPr_GR_II.Unfilt ) / 2;
			ELSE  
				IF  ABS(IN_GT.tPr_GR_I.Ai- (rPr_MGT_sp + IN_GT.rPr_Baro_Internal)) <  ABS(IN_GT.tPr_GR_II.Ai - (rPr_MGT_sp + IN_GT.rPr_Baro_Internal))  THEN
			 		rPr_GR_Avg_UF := IN_GT.tPr_GR_I.Unfilt;
				ELSE
					rPr_GR_Avg_UF := IN_GT.tPr_GR_II.Unfilt;
				END_IF;
			END_IF;		
		END_IF;
		OUT_GT.rPr_GR_UF := rPr_GR_Avg_UF;

		(*----------------------------------------------------------*)	
		(* calculate differential pressure 							*)
		(*----------------------------------------------------------*)	
		rPr_MGT_Diff := OUT_GT.rPr_GR_filt - IN_GT.rPr_Ch_P2s_Avg;

		(*------------------------------------------------------------------*)	
		(* differential pressure minimum / power reduction					*)
		(*------------------------------------------------------------------*)	
		
		(* charge pressure depending limit calculation *)
		IF bRelMon_Pr_GR_Avg AND OUT_GT.tGV1_Open.Do THEN
			xGR_MIN_Red1_DP(In := (rPr_MGT_Diff / xSigScal_R_DPr_MGT_sp.Y_SCAL), Gw := Perm2.rDPr_limit_pgr_Pred, Hy := rHy_GR_MIN);
			IF xGR_MIN_Red1_DP.Q THEN
				OUT_GT.rP2s_red_1 := (OUT_GT.rPr_GR_filt - (Perm2.rDPr_limit_pgr_Pred * xSigScal_R_DPr_MGT_sp.Y_SCAL));
				rP_norm_red_1	  := LIMIT(0.0, (IN_GT.rP_el_max_red / MAX(1, IN_GT.rP_Nom)), 1.0);
			ELSE
				rP_norm_red_1 := 1.00;
			END_IF;
			
			IF Para.bPr_GR_red_Exist THEN
				IF ((Para.rPr_GR_red_start - IN_GT.tPr_MGT_a_Filt.Ai) * Para.rP_Pr_GR_red_rate) < 1.0 THEN
					rP_norm_red_2 := LIMIT(0.0, (1 - ((Para.rPr_GR_red_start - IN_GT.tPr_MGT_a_Filt.Ai) * Para.rP_Pr_GR_red_rate)), 1.0);
				ELSE
					rP_norm_red_2 := 1.00;
				END_IF;
			ELSE
				rP_norm_red_2 := 1.00;
			END_IF;
			
			IF IN_GT.tGCB_On.Di THEN
				OUT_GT.rP_Red_Pr_GR_Norm :=	MIN(rP_norm_red_1, rP_norm_red_2);
			ELSE	
				OUT_GT.rP_Red_Pr_GR_Norm	:= 1.0;	
			END_IF;	

			IF ((IN_GT.tPr_MGT_a_Filt.Ai - (rPr_GR_Avg - IN_GT.rPr_Baro_Internal)) < rPr_GR_Threshold) THEN
				xTP_Pr_MGT_a_Filt_Min(IN := TRUE, PT := T#2s);
			ELSE
				xTP_Pr_MGT_a_Filt_Min(IN := FALSE, PT := T#2s);
			END_IF;	

			bAMM_Pr_MGT_a_Filt_Min := xTP_Pr_MGT_a_Filt_Min.Q;	
		ELSE	
			xTP_Pr_MGT_a_Filt_Min(IN := FALSE, PT := T#2s);	
		END_IF;	

	END_IF;
		
END_PROGRAM