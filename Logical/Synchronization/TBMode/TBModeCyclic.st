(*******************************************************************************
TbMode		test bench mode

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V3.99.0	26.02.2013	lettenb.	new
		19.11.2013				OUT_SY.bSmoothDischarge := FALSE; (IF OUT_SY.bTestBenchModeIsland) bugfix 
V4.00.0 12.06.2014	lettenb.	test bTestBenchModeIsland
V4.03.0	14.08.2015	lettenb.	OUT_SY.bOnly_Island	logic for standard mode corr. removed (bugfix/pfanzagl)
V4.13.0	29.11.2023	Goenczi		SmoothDischarge set in CU module
																																
Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(******************************************************************************)
	(* test-bench mode timeout control *)                        (* from settings *)
	
	xTON_PRF(IN:= IN_SY.tTBMode.Di, PT:= T#10s);
	xR_TRIG_PRF(CLK:= xTON_PRF.Q);

	IF NOT IN_SY.tTBMode.Di OR NOT IN_SY.tPB2MM.bSys_Run THEN
		xTOF_PRF(IN:= FALSE, PT:= T#0s);	(* reset timer *)
	ELSE
		xTOF_PRF(IN:= xR_TRIG_PRF.Q AND IN_SY.tPB2MM.bSys_Run, PT:= T#12h);
	END_IF;
	
	xTON_NP(IN:= IN_SY.tReq_PowMod.Di, PT:= T#10s);

	OUT_SY.bTestBenchModeIsland		:=	xTOF_PRF.Q 
								AND NOT xTON_NP.Q 
								AND NOT Para.bMCB_Enable 
								AND NOT Para.bMCB_Ctr_Cust 
								AND	   (IN_SY.tMCB_Off.Di OR NOT IN_SY.tMCB_Off.GoodQual)
								AND 	IN_SY.tC_CB_Off.Di;

	OUT_SY.bTestBenchModeParallel	:=	xTOF_PRF.Q 
								AND     xTON_NP.Q 
								AND NOT Para.bMCB_Enable 
								AND NOT Para.bMCB_Ctr_Cust 
								AND NOT Para.bMSy;

	bTestBenchMode	:=	OUT_SY.bTestBenchModeIsland OR OUT_SY.bTestBenchModeParallel;		(* test-bench mode *)
	
	(******************************************************************************)

	
	
	(*-----------------------------------------------------------------------------*)
	(* TestBenchMode - write in interfaces *)                      (* from pb17_en *)
	(*-----------------------------------------------------------------------------*)
	//	(* enable netp.operation for test-bench run *)	
	IF	OUT_SY.bTestBenchModeParallel THEN
		IF	Para.bOnlyIsland_Enable THEN
			IN_SY.tMnsOk.Di	:=	OUT_SY.bMCB_On;
		END_IF;		
	END_IF;


	(* switch standard-inputs esy to nonexisting required inputs esy *)
	IF OUT_SY.bTestBenchModeIsland THEN
		IF	Para.bMSy AND Para.bSyActive THEN
			IN_SY.tGCB_AGO.Di	:=	TRUE;		(* enable closing gcb for test-bench run *)
		END_IF;
	END_IF;



	(*-----------------------------------------------------------------------------*)
	(* TestBenchMode - write out interfaces *)                  (* from ex pb17_en *)
	(*-----------------------------------------------------------------------------*)
	IF        OUT_SY.bTestBenchModeIsland THEN
		OUT_SY.bMCB_On			:=  IN_SY.tMCB_On.Di AND IN_SY.tMnsOk.Di;	(* mcb closed for engine control and RPS *)	
		OUT_SY.bSmoothDischarge	:=	FALSE;									(* smoothly discharging power in island operation *)

	ELSIF NOT OUT_SY.bTestBenchModeIsland THEN
		OUT_SY.bMCB_On			:=  IN_SY.tMCB_On.Di;					
		OUT_SY.bSmoothDischarge	:=	IN_SY.bSmoothDischarge_CU;
	END_IF;


	IF OUT_SY.bTestBenchModeParallel THEN
		OUT_SY.bOnly_Island	:= FALSE;
	ELSE
		IF OUT_SY.bTestBenchModeIsland THEN
			OUT_SY.bOnly_Island	:= (Para.bOnlyIsland_Enable OR	Para.bMSy);	(* enable only isl. op. for test-bench run *)
		ELSE	
			OUT_SY.bOnly_Island	:=  Para.bOnlyIsland_Enable					(* enable only isl. op. as standard mode *)
							  OR   (Para.bMSy AND IN_SY.tOnly_Island.Di);
		END_IF;	
	END_IF;	

	
	(*-----------------------------------------------------------------------------*)

END_PROGRAM
