(*******************************************************************************
c_aux 			customized auxiliaries #21-30 for visualization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
V3.20.0	14-10-2010 lettenb.	new, function moved from fb31_hb	
V3.21	04.09.2013 zengerer _Active typ changed to INT (entspr. DianeWIN Version)
V3.22	12.09.2013 zengerer MM2Vis added
V4.00.1	09.05.2014 zengerer	do no predefinition for parameter values, this causes VIS troubles!
				 			beta bugfix: reduced Para update speed to hardcoded defaults with 'bSetFixParaToDefault' bit to avoid VIS troubles with hardcoded para values
							bEC_Rel, bChC_Rel included from MM_HC
V4.04.0	08.11.2016 lettenb.	OUT_CU.bEC_Rel: Para.bAuxEC_Visible added(stary)
V4.07.0	09.08.2018 Schmid	2nd low temperature charge cooling circuit added (bChC2_Rel)
V4.07.0	27.02.2019 zengerer remove parameter preparation, beta defaults with 'bSetFixParaToDefault' removed
V4.11.0	17.12.2021 Schmid	control battery check
		20.01.2022 zengerer Reintegrate Customer Extention Package
V4.11.1	14.02.2022 Schmid	GoodQual default TRUE for control battery check supply monitoring
		23.02.2022 lettenb. OUT_CU.bChC_Rel: bMsg2117(charge cooler water pressure low) removed, request system owner, bugfix
V4.11.2	23.02.2022 Schmid	+M control battery check option removed - covered by buffer battery check (coordinated execution with starter battery check required)
V4.13.0	24.08.2023 Zengerer IN_CU.bMsg[xxxx] introduced

Instructions for use:
--------------------
connect var for display customized auxiliaries 
AVOID HARDCODED PARAMETER VALUES! Set display typ of each aux in parameter file.

Outstandings:
------------
bSetFixParaToDefault?

*******************************************************************************)
PROGRAM _CYCLIC	
	(*------------------------------------------------------------------------------------------*)
	(* release emergency cooler from monitoring (remove not applicable parts) (ex K_frg) *)
	OUT_CU.bEC_Rel 	:=  NOT IN_CU.bMsg[1031]
			        AND NOT IN_CU.bMsg[1053]  
					AND NOT IN_CU.bMsg[1054]
					AND NOT IN_CU.bMsg[3404] 
					AND(NOT IN_CU.bMsg[2117] OR Para.bAuxEC_Visible) (* for EngineVis >= 2.5.x *)
					AND NOT IN_CU.bMsg[1019];

	(* release charge cooler from monitoring (remove not applicable parts) (ex GK_frg) *)
	OUT_CU.bChC_Rel	:=  NOT IN_CU.bMsg[1031]
					AND NOT IN_CU.bMsg[1053] 
					AND NOT IN_CU.bMsg[1054]; 

	(* release charge cooler 2 from monitoring (remove not applicable parts) *)
	OUT_CU.bChC2_Rel	:=  NOT IN_CU.bMsg[1031]
						AND NOT IN_CU.bMsg[1053]
						AND NOT IN_CU.bMsg[1054]
						AND NOT IN_CU.bMsg[9226];		

	(*------------------------------------------------------------------------------------------*)	
	(* control battery voltage check *)
	iOptLocation_CtrlBatMon[1]	:=	1;		// set index variable according to position of battery test set
	iOptLocation_CtrlBatMon[2]	:=	2;		// predefined options: 1: +A / 2: +AUX1 / 3: +AUX2 / 4: +CUSTOM
	iOptLocation_CtrlBatMon[3]	:=	3;		// not used test sets can remain in default setting - GoodQual detects usage automatically
	iOptLocation_CtrlBatMon[4]	:=	4;		// for customization see instructions below
	
	(*iOptLocation_CtrlBatMon contains the location of control battery test sets (control cabinets)
	In the preconfigured status, in position 1 there is the measure +A, in position 2 the measure +AUX1, in position 2 the measure +AUX2 and in position 4 the measure +CUSTOM
	For example, when iOptLocation_CtrlBatMon = [2,1,3,4], in position 1 there is the measure +AUX1, in position 2 the measure +A, in position 3 the measure +AUX2 and in position 4 the measure +CUSTOM
	*)
	
	
	FOR iIdx_CtrlBatMon := 1 TO iNum_CtrlBatMon DO
		CASE iOptLocation_CtrlBatMon[iIdx_CtrlBatMon] OF
			1:	(* +A *)
				OUT_CU.sLocIdent_CtrlBatMon[iIdx_CtrlBatMon]	:=	'+A';																// control cabinet location of test set
				OUT_CU.bAuxV_ok_CtrlBatMon[iIdx_CtrlBatMon]		:=	IN_CU.tAuxV_Supply_Ok.Di	OR NOT IN_CU.tAuxV_Supply_Ok.GoodQual;	// according supply voltage status
				
			2:	(* +AUX1 *)
				OUT_CU.sLocIdent_CtrlBatMon[iIdx_CtrlBatMon]	:=	'+AUX1';
				OUT_CU.bAuxV_ok_CtrlBatMon[iIdx_CtrlBatMon]		:=	IN_CU.tAuxV_Aux_ok.Di		OR NOT IN_CU.tAuxV_Aux_ok.GoodQual;
				
			3:	(* +AUX2 *)
				OUT_CU.sLocIdent_CtrlBatMon[iIdx_CtrlBatMon]	:=	'+AUX2';
				OUT_CU.bAuxV_ok_CtrlBatMon[iIdx_CtrlBatMon]		:=	IN_CU.tAuxV_Aux_ok.Di		OR NOT IN_CU.tAuxV_Aux_ok.GoodQual;
				
			4:	(* +CUSTOM *)
				OUT_CU.sLocIdent_CtrlBatMon[iIdx_CtrlBatMon]	:=	'+CUSTOM';
				OUT_CU.bAuxV_ok_CtrlBatMon[iIdx_CtrlBatMon]		:=	FALSE;	//IN_CU.tAuxV_CUSTOM_ok.Di OR NOT IN_CU.tAuxV_CUSTOM_ok.GoodQual;
		END_CASE;
	END_FOR;
	
	(* if customized adjustments (location, voltage supply) are required, overwrite elements in the following: *)
	//	OUT_CU.sLocIdent_CtrlBatMon[1..4]	:=	'+XYZ';
	//	OUT_CU.bAuxV_ok_CtrlBatMon[1..4]	:=	IN_CU.tAuxV_CUSTOM_ok.Di OR NOT IN_CU.tAuxV_CUSTOM_ok.GoodQual;
	
	(*------------------------------------------------------------------------------------------*)	

	OUT_CU.bAuxCust_Dem[1]	;//:=	FALSE;		(* reserve auxiliary  #1 		*)		(* Connect your customisation variable here; VIS: customize texts! *)
	(*Hint: Set VIS appearance with Para.iAuxCust_Active[1]:	 0=invisible, 1=ON/OFF, 2=OPEN/CLOSED	*)	(* 0=keine Anzeige, 1=EIN/AUS, 2=OFFEN/GESCHLOSSEN) *) 
	(*IN_CU.tManAuxCtr.bAuxCust[x] 1-10 prepared *)	(* change customized *)
	
	OUT_CU.bAuxCust_Dem[2]	;//:=	FALSE;		(* reserve auxiliary  #2 		*)		(* Connect your customisation variable here; VIS: customize texts! *)
	
	OUT_CU.bAuxCust_Dem[3]	;//:=	FALSE;		(* reserve auxiliary  #3 		*)		(* Connect your customisation variable here; VIS: customize texts! *)
	
	OUT_CU.bAuxCust_Dem[4]	;//:=	FALSE;		(* reserve auxiliary  #4 		*)	
	
	OUT_CU.bAuxCust_Dem[5]	;//:=	FALSE;		(* reserve auxiliary  #5 		*)	
	
	OUT_CU.bAuxCust_Dem[6]	;//:=	FALSE;		(* reserve auxiliary  #6 		*)	
	
	OUT_CU.bAuxCust_Dem[7]	;//:=	FALSE;		(* reserve auxiliary  #7 		*)	
	
	OUT_CU.bAuxCust_Dem[8]	;//:=	FALSE;		(* reserve auxiliary  #8 		*)
	
	OUT_CU.bAuxCust_Dem[9]	;//:=	FALSE;		(* reserve auxiliary  #9 		*)
	
	OUT_CU.bAuxCust_Dem[10]	;//:=	FALSE;		(* reserve auxiliary  #10		*)	
	


	OUT_CU.bAuxCust_Dem[11]	;//:=	FALSE;		(* reserve auxiliary #11 		*)	
	
	OUT_CU.bAuxCust_Dem[12]	;//:=	FALSE;		(* reserve auxiliary #12 		*)
	
	OUT_CU.bAuxCust_Dem[13]	;//:=	FALSE;		(* reserve auxiliary #13 		*)

	OUT_CU.bAuxCust_Dem[14]	;//:=	FALSE;		(* reserve auxiliary #14 		*)
		
	OUT_CU.bAuxCust_Dem[15]	;//:=	FALSE;		(* reserve auxiliary #15 		*)
	
	OUT_CU.bAuxCust_Dem[16]	;//:=	FALSE;		(* reserve auxiliary #16 		*)
	
	OUT_CU.bAuxCust_Dem[17]	;//:=	FALSE;		(* reserve auxiliary #17 		*)
	
	OUT_CU.bAuxCust_Dem[18]	;//:=	FALSE;		(* reserve auxiliary #18 		*)
	
	OUT_CU.bAuxCust_Dem[19]	;//:=	FALSE;		(* reserve auxiliary #19 		*) 
	
	OUT_CU.bAuxCust_Dem[20]	;//:=	FALSE;		(* reserve auxiliary #20 		*) 



	OUT_CU.bAuxCust_Dem[21]	;//:=	FALSE;		(* reserve auxiliary #21 		*)	
	(*Hint: Set VIS aperance with Para.iAuxCust_Active[21]:	 0=invisible, 1=ON/OFF, 2=OPEN/CLOSED	*)	(* 0=keine Anzeige, 1=EIN/AUS, 2=OFFEN/GESCHLOSSEN) *) 
	
	OUT_CU.bAuxCust_Dem[22]	;//:=	FALSE;		(* reserve auxiliary #22 		*)
	
	OUT_CU.bAuxCust_Dem[23]	;//:=	FALSE;		(* reserve auxiliary #23 		*)
	
	OUT_CU.bAuxCust_Dem[24]	;//:=	FALSE;		(* reserve auxiliary #24		*)
		
	OUT_CU.bAuxCust_Dem[25]	;//:=	FALSE;		(* reserve auxiliary #25 		*)
	
	OUT_CU.bAuxCust_Dem[26]	;//:=	FALSE;		(* reserve auxiliary #26 		*)
	
	OUT_CU.bAuxCust_Dem[27]	;//:=	FALSE;		(* reserve auxiliary #27 		*)
	
	OUT_CU.bAuxCust_Dem[28]	;//:=	FALSE;		(* reserve auxiliary #28 		*)
	
	OUT_CU.bAuxCust_Dem[29]	;//:=	FALSE;		(* reserve auxiliary #29 		*) 
	
	OUT_CU.bAuxCust_Dem[30]	;//:=	FALSE;		(* reserve auxiliary #30 		*) 



	OUT_CU.bAuxCust_Dem[31]	;//:=	FALSE;		(* reserve auxiliary #31 		*)	
	
	OUT_CU.bAuxCust_Dem[32]	;//:=	FALSE;		(* reserve auxiliary #32 		*)
	
	OUT_CU.bAuxCust_Dem[33]	;//:=	FALSE;		(* reserve auxiliary #33 		*)
	
	OUT_CU.bAuxCust_Dem[34]	;//:=	FALSE;		(* reserve auxiliary #34		*)
		
	OUT_CU.bAuxCust_Dem[35]	;//:=	FALSE;		(* reserve auxiliary #35 		*)
	
	OUT_CU.bAuxCust_Dem[36]	;//:=	FALSE;		(* reserve auxiliary #36 		*)
	
	OUT_CU.bAuxCust_Dem[37]	;//:=	FALSE;		(* reserve auxiliary #37 		*)
	
	OUT_CU.bAuxCust_Dem[38]	;//:=	FALSE;		(* reserve auxiliary #38 		*)
	
	OUT_CU.bAuxCust_Dem[39]	;//:=	FALSE;		(* reserve auxiliary #39 		*) 

	OUT_CU.bAuxCust_Dem[40]	;//:=	FALSE;		(* reserve auxiliary #40 		*) 
	(*Hint: Set VIS aperance with Para.iAuxCust_Active[40]:	 0=invisible, 1=ON/OFF, 2=OPEN/CLOSED	*)	(* 0=keine Anzeige, 1=EIN/AUS, 2=OFFEN/GESCHLOSSEN) *) 

	
	(*** DEFAULT CONFIG END ********************************************************************************************************)
	(*** DEFAULT CONFIG END  - ADD VIS EXTENTION PACKAGE also, to use more than the default number of channels *********************)
	(*** DEFAULT CONFIG END ********************************************************************************************************)
	
	OUT_CU.bAuxCust_Dem[41];//:=	FALSE;		(* reserve auxiliary #41		*) 	(*import HMI Extension *)						
	OUT_CU.bAuxCust_Dem[42];//:=	FALSE;		(* reserve auxiliary #42		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[43];//:=	FALSE;		(* reserve auxiliary #43		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[44];//:=	FALSE;		(* reserve auxiliary #44		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[45];//:=	FALSE;		(* reserve auxiliary #45		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[46];//:=	FALSE;		(* reserve auxiliary #46		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[47];//:=	FALSE;		(* reserve auxiliary #47		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[48];//:=	FALSE;		(* reserve auxiliary #48		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[49];//:=	FALSE;		(* reserve auxiliary #49		*) 	(*import HMI Extension *)

	OUT_CU.bAuxCust_Dem[50];//:=	FALSE;		(* reserve auxiliary #50		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[51];//:=	FALSE;		(* reserve auxiliary #51		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[52];//:=	FALSE;		(* reserve auxiliary #52		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[53];//:=	FALSE;		(* reserve auxiliary #53		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[54];//:=	FALSE;		(* reserve auxiliary #54		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[55];//:=	FALSE;		(* reserve auxiliary #55		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[56];//:=	FALSE;		(* reserve auxiliary #56		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[57];//:=	FALSE;		(* reserve auxiliary #57		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[58];//:=	FALSE;		(* reserve auxiliary #58		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[59];//:=	FALSE;		(* reserve auxiliary #59		*) 	(*import HMI Extension *)

	OUT_CU.bAuxCust_Dem[60];//:=	FALSE;		(* reserve auxiliary #60		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[61];//:=	FALSE;		(* reserve auxiliary #61		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[62];//:=	FALSE;		(* reserve auxiliary #62		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[63];//:=	FALSE;		(* reserve auxiliary #63		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[64];//:=	FALSE;		(* reserve auxiliary #64		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[65];//:=	FALSE;		(* reserve auxiliary #65		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[66];//:=	FALSE;		(* reserve auxiliary #66		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[67];//:=	FALSE;		(* reserve auxiliary #67		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[68];//:=	FALSE;		(* reserve auxiliary #68		*) 	(*import HMI Extension *)
	OUT_CU.bAuxCust_Dem[69];//:=	FALSE;		(* reserve auxiliary #69		*) 	(*import HMI Extension *)
						
	OUT_CU.bAuxCust_Dem[70];//:=	FALSE;		(* reserve auxiliary #70		*) 	(*import HMI Extension *)
	
	(*------------------------------------------------------------------------------*)
	(*						  NO CHANGES BEJOND THIS LINE!			 				*) 
	(*------------------------------------------------------------------------------*)	

	MM2VIS.bAuxCust		 :=	OUT_CU.bAuxCust_Dem			;		(* forward status info to visualisation display (with check of exact matching array size) *)

	(*generate artificial parameter state changes - REMOVED *)

	
	
END_PROGRAM
