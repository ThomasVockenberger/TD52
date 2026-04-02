(********************************************************************
ereg	 			 generator excitation voltage

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019


Customized modifications: -
------------------------
 
History:
-------

V0.1  	27.10.98/Pa	  			Created 
      	24.11.98/Pa	  			Proofread
V170  	15.04.02/LH	  			Delay in excitation voltage minimum => 10sec
V180  	06.03.03/LH	  			VISU- Limit values only after recipe is on controller
      	18.03.03/LH	  			Read analog input -> pb17
V190  	19.04.04/LH	  			Limit value excitation voltage maximum 
V350  	25.02.13/HG,IG  		Modular software - new "english" names, moved filtering & scaling to HAL
		06.06.2016	lettenb.	M_DREHZ added, set value to zero if engine stand still acc.XT3, bugfix
V4.10.0	14.12.2020	lettenb.	TON,TOF reset added to avoid time overrun, cleanup

Instructions for use: - 
--------------------
			
Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC

	IF Para.bU_Gen_Exc_Ena AND M_DREHZ THEN
		(* Generator excitation activated *)
		
		(* Set point excitation voltage minimum *)
		xGRMinFA_AN_ERGW1.In := IN_GC.tU_Gen_Exc.Ai;
		xGRMinFA_AN_ERGW1.Gw := Para.rU_Gen_ExcLo;
		xGRMinFA_AN_ERGW1.Hy := Para.rU_Gen_ExcHyLo;
		xGRMinFA_AN_ERGW1();
		xTON_FA_T_ERGW1.IN   := xGRMinFA_AN_ERGW1.Q AND IN_GC.tPB2MM.bParaSetupOk;
		xTON_FA_T_ERGW1.PT   := T#10s;
		xTON_FA_T_ERGW1();
		bU_Gen_Exc_Min       := xTON_FA_T_ERGW1.Q;

		(* Set point excitation voltage maximum *)
		xGRMaxFA_AN_ERGW2.In := IN_GC.tU_Gen_Exc.Ai;
		xGRMaxFA_AN_ERGW2.Gw := Para.rU_Gen_ExcHi;
		xGRMaxFA_AN_ERGW2.Hy := Para.rU_Gen_ExcHyHi;
		xGRMaxFA_AN_ERGW2();	
		xTON_FA_T_ERGW2.IN   := xGRMaxFA_AN_ERGW2.Q AND IN_GC.tPB2MM.bParaSetupOk;
		xTON_FA_T_ERGW2.PT   := T#30s;
		xTON_FA_T_ERGW2();
		bU_Gen_Exc_Max       := xTON_FA_T_ERGW2.Q;

		OUT_GC.rU_Gen_Exc    := IN_GC.tU_Gen_Exc.Ai;
		
	ELSE
		xTON_FA_T_ERGW1(IN:= FALSE, PT:= T#0s);
		xTON_FA_T_ERGW2(IN:= FALSE, PT:= T#0s);

		bU_Gen_Exc_Min     := FALSE;
		bU_Gen_Exc_Max     := FALSE;
		OUT_GC.rU_Gen_Exc  := 0.0;
		
	END_IF;
	
END_PROGRAM
