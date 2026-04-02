(********************************************************************************************************
PUscuffDet: 	crankcase pressure and knock noise signal based power-unit scuffing detection (cyclic)	

This code is confidential AND proprietary TO the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission OF the INNIO Company.
Copyright, INNIO Company, 2022


Customized modifications: 
------------------------
 
History:
-------
V4.11.00	14.01.2022	Schmidt		created

Outstandings:
------------
-
********************************************************************************************************)

PROGRAM _CYCLIC
	
	(* Parameters *)
	xPUscuff.Para.bPUscf_Ena 				:= Para.bPUscf_Ena AND xEngType.Type6 AND Para.bSA_KLS_Active;
	xPUscuff.Para.rTiPUscf_EnaDelay			:= Para.rTiPUscf_EnaDelay;
	xPUscuff.Para.rPUscf_Eps_scale			:= Para.rPUscf_Eps_scale;
	xPUscuff.Para.rTiPUscf_LearnReactDelay	:= Para.rTiPUscf_LearnReactDelay;
	xPUscuff.Para.rPr_CC_PUscf_Dev_HiHi		:= Para.rPr_CC_PUscf_Dev_HiHi*1000;
	xPUscuff.Para.rPUscf_LearnScale			:= Para.rPUscf_LearnScale;
	
	(* Inputs *)
	xPUscuff.In.bKnockSig 					:= IN_EG.bKnockSig;
	xPUscuff.In.rKnockNoise					:= IN_EG.rKnck_Noise;
	xPUscuff.In.iNumCyl						:= xEngType.NumberOfCylinder;
	xPUscuff.In.rP2s 						:= IN_EG.rPr_Ch_P2s_Avg;
	xPUscuff.In.rP_Act_Norm					:= IN_EG.rP_Act_Norm;
	xPUscuff.In.tPr_CC_Ai					:= (IN_EG.tPr_CC.Ai + rPr_CC_Ai_Offs)*1000;
	xPUscuff.In.tPr_CC_GoodQual				:= IN_EG.tPr_CC.GoodQual;
	xPUscuff.In.tGCB_On_Di 					:= IN_EG.tGCB_On.Di;
	xPUscuff.In.rKnockNoise					:= IN_EG.rKnck_Noise;
	
	(* Function execution *)
	xPUscuff();
	
	(* Outputs *)
	xPUscuff.Out.bPUscf_LearnEna;
	xPUscuff.Out.bPUscf_RelTrip;
	xPUscuff.Out.bPUscf_TripALL;
	xPUscuff.Out.bYpredict;
	xPUscuff.Out.rPr_CC_pred;
	xPUscuff.Out.tPUscuff_Map;
	
	(********************************************************************************************************************************)
	(************************              				 AMM sequencer	 		             	           **************************)
	(********************************************************************************************************************************)
	xTON_SecondTick(IN := NOT xTON_SecondTick.Q, PT:= T#800ms);					(* 800ms + 2x cycle time = 1 sec.*)
	
	(* Power-unit scuffing detection operating message *)
	xAmmSeq_PUscuff.Enable		:= NOT IN_EG.tAB2EG.bResetWarning; 
	xAmmSeq_PUscuff.ClockPulse	:= xTON_SecondTick.Q; 
	xAmmSeq_PUscuff.NrOfBits	:= 25; 
	xAmmSeq_PUscuff.BitArray	:= ADR(xPUscuff.Out.bYpredict);
	xAmmSeq_PUscuff();
	
	bAMM_PUscuff				:= xPUscuff.Out.bPUscf_TripALL;
	bOpM_PUscuff				:= xAmmSeq_PUscuff.Alarm2;
	iNum_Msg2981				:= xAmmSeq_PUscuff.ErrorNr;
	
	(********************************************************************************************************************************)
	(************************              						VISU	 	             	   	        	*************************)
	(********************************************************************************************************************************)

	MM2VIS.iNum_Msg2981 	:= iNum_Msg2981;
	MM2VIS.bPUscf_RelTrip 	:= xPUscuff.Out.bPUscf_RelTrip;
	MM2VIS.bPUscf_LearnEna 	:= xPUscuff.Out.bPUscf_LearnEna;
	MM2VIS.rPr_CC_pred 		:= xPUscuff.Out.rPr_CC_pred;

END_PROGRAM