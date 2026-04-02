(****************************************************************************************************************************
FiltUnit		Oil filter unit (CYCLIC)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.04.00.00		24.05.2016 TinelloM	erstellt
				01.09.2016 TinelloM	Anpassung an Speziupdate
V4.07.00.00		13.05.2019 Schmid	OUT interface OUT_AG.rDPr_OFU_Filt added
V4.09.00.00		05.03.2020 Schmid	oil centrifuge must not run at interval/perm. prelube
V4.11.00.00		21.12.2021 Schmid	pressure before oil centrifuge min warning added

(****************************************************************************************************************************)
PROGRAM _CYCLIC

	IF Para.bOilFiltUnit_Exist AND IN_AG.tPB2MM.bParaSetupOk THEN
				
		(* monitoring of oilfilter difference pressure *)
		rDPr_OFU_Filt				:= IN_AG.tPr_OFUbFilt.Ai - IN_AG.tPr_OFUaFilt.Ai;

		bAMM_DPr_OFU_Filt_Hi		:= (rDPr_OFU_Filt 	> Para.rDPr_OFU_Filt_LimHi) 				AND				(* W2629 *)
										 Para.bPr_OFUbFilt_Active 	AND  Para.bPr_OFUaFilt_Active  	AND
										IN_AG.tPr_OFUbFilt.GoodQual	AND IN_AG.tPr_OFUaFilt.GoodQual;

		bAMM_DPr_OFU_Filt_HiHi		:= (rDPr_OFU_Filt 	> Para.rDPr_OFU_Filt_LimHi + 2) 			AND	(* +2bar *)	(* W2422 *)
										 Para.bPr_OFUbFilt_Active 	AND  Para.bPr_OFUaFilt_Active  	AND
										IN_AG.tPr_OFUbFilt.GoodQual	AND IN_AG.tPr_OFUaFilt.GoodQual;


		(* monitoring of pressure maximum *)
		bAMM_Pr_OFUbFilt_Hi			:= IN_AG.tPr_OFUbFilt.Ai > Para.rPr_OFUbFilt_Hi	AND								(* W2785 *)
									    Para.bPr_OFUbFilt_Active	AND 
									   IN_AG.tPr_OFUbFilt.GoodQual;

		bAMM_Pr_OFUbCentrifuge_Hi	:= IN_AG.tPr_OFUbCentrifuge.Ai > Para.rPr_OFUbCentrifuge_Hi AND					(* W2787 *)
									    Para.bPr_OFUbCentrifuge_Active 	AND 
									   IN_AG.tPr_OFUbCentrifuge.GoodQual;


		(* monitoring of pressure minimum *)
		xTON_AMM_Centrifuge_Pr_Lo_MonRel(IN:= OUT_AG.tOFUP_Centrifuge.Do, PT:= T#5m);
		
		bAMM_Pr_OFUbCentrifuge_Lo	:=	IN_AG.tPr_OFUbCentrifuge.Ai < Para.rPr_OFUbCentrifuge_Lo			(* W9359 *)
									AND	xTON_AMM_Centrifuge_Pr_Lo_MonRel.Q
									AND	Para.bPr_OFUbCentrifuge_Active
									AND IN_AG.tPr_OFUbCentrifuge.GoodQual;
									   

		(* oil pump centrifuge / M.03-P-006 *)
		xTOF_OFUP_Centrifuge_Dem(IN:= bPreLubeDem OR M_DREHZ, PT:= T#10m);
		OUT_AG.tOFUP_Centrifuge.Do	:= bOMSS_MAT					AND					(* panel switch ON *)
									   IN_AG.tOFUP_Centrifuge_CB.Di	AND					(* oil centrifuge circuit breaker OK *)
									   NOT bGnlTrip					AND			 		(* no trip *)
									   IN_AG.tT_EO_Pan.Ai > 70 		AND					(* temp. oil pan > 70°C *)
									   NOT MM2VIS.bMsg2786			AND					(* press. before centrifuge sig. Err *)
									   NOT MM2VIS.bMsg2787			AND					(* press. before centrifuge maximum *)
									   xTOF_OFUP_Centrifuge_Dem.Q;						(* oil pump in operation *)

		(* oil pump oilfilter / M.03-P-007 *)
			xTON_Centrifuge(IN		:= OUT_AG.tOFUP_Centrifuge.Do, PT:= T#2s );

		OUT_AG.tOFUP_Filter.Do		:= xTON_Centrifuge.Q			AND					(* no start of both pumps together *)
									   IN_AG.tOFUP_Filter_CB.Di		AND					(* oilfilter pump circuit breaker OK *)
									   NOT MM2VIS.bMsg2627			AND					(* press. before oil filter sig. Err *)
									   NOT MM2VIS.bMsg2628			AND					(* press. after oil filter sig. Err *)
									   NOT MM2VIS.bMsg2785			AND					(* press. before oil filter maximum *)
									   NOT MM2VIS.bMsg2422;								(* diff press < limit + 2bar *)
								
	ELSE
		(* reset *)
		bAMM_DPr_OFU_Filt_Hi		:= FALSE;
		bAMM_DPr_OFU_Filt_HiHi		:= FALSE;
		bAMM_Pr_OFUbFilt_Hi			:= FALSE;
		bAMM_Pr_OFUbCentrifuge_Hi	:= FALSE;
		bAMM_Pr_OFUbCentrifuge_Lo	:= FALSE;
		xTON_AMM_Centrifuge_Pr_Lo_MonRel(IN:= FALSE);
		xTOF_OFUP_Centrifuge_Dem(IN:= FALSE);
		xTON_Centrifuge(IN:= FALSE);
		OUT_AG.tOFUP_Centrifuge.Do	:= FALSE;
		OUT_AG.tOFUP_Filter.Do		:= FALSE;
		rDPr_OFU_Filt				:= 0;
	END_IF


	(* VISU *)
	MM2VIS.rPr_OFUbCentrifuge		:= IN_AG.tPr_OFUbCentrifuge.Ai;
	MM2VIS.rPr_OFUaFilt				:= IN_AG.tPr_OFUaFilt.Ai;
	MM2VIS.rPr_OFUbFilt 			:= IN_AG.tPr_OFUbFilt.Ai;
	MM2VIS.rDPr_OFU_Filt			:= rDPr_OFU_Filt;
	MM2VIS.bOFUP_Centrifuge			:= OUT_AG.tOFUP_Centrifuge.Do;
	MM2VIS.bOFUP_Filter				:= OUT_AG.tOFUP_Filter.Do;

	OUT_AG.rDPr_OFU_Filt			:= rDPr_OFU_Filt;

END_PROGRAM
