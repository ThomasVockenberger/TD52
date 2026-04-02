(*******************************************************************************
MsgAB	 			 alarms generation 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V0.01.0	02.11.2011	lettenb.	new
V3.99.0	07.03.2013	lettenb.	cleanup
		24.05.2013				reset OUT_xx.txx2AB.bGnlTripx changed
		07.11.2013				bMsg3003 removed, cleanup
V4.00.0	27.02.2014				logger added
V4.00.1	17.12.2014				3003 modif.for 920(920 stapelfeld), enable with IN_AB.tPB2MM.bSys_Run
V4.04.0	21.10.2016	lettenb.	3003(2103,2104) modif.for functional safety(thummer/feyrsinger/gföller)
		28.07.2017	502423184	no shut down due TO a measuring signal failure, SWAT #3
V4.05.0	22.12.2017	lettenb.	comment added: Safety-related application software source code (EN 13849-1 / 4.6.3)#
		22.01.2018	lettenb.	3003 bSys_Run -> bParaSetupOk to avoid message at plc startup
V4.13.0	04.12.2023	Bencze		Risk Class 10 for remote reset of safety trips 
V4.14.0 06.11.2024 Nagy bMsg3152 Room Temperature Signal Failure removed from A3003 2024-226 Trip Desent
								
Instructions for use:
--------------------
1) declare alarm with function block "Msg"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset acc.TI 1100-0111
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	
	bMsg0000_Test		:=	xMsg0000.Test; alarm bypass active

3)  expand INIT

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	tMM2AB.bGnlTrip1	:=	FALSE;
	tMM2AB.bGnlTrip2	:=	FALSE;
	tMM2AB.bGnlTrip3	:=	FALSE;
	tMM2AB.bGnlWarning	:=	FALSE;
	tMM2AB.bTriptype1	:=	FALSE;
	tMM2AB.bTriptype2	:=	FALSE;
	tMM2AB.bTriptype3	:=	FALSE;	
	

	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): BEGIN
	*********************************************************************************************************************)
	(* W3003 signal failure( 2101 or 2102 or 2103 or 2104 *)
	xMsg3003.Enable	   := IN_AB.tPB2MM.bParaSetupOk;
	IF xEngType.Type9 THEN

		xMsg3003.Set   :=   IN_AB.bMsg2101
						OR  IN_AB.bMsg2102
	//					OR  IN_AB.bMsg2103		(* no shut down due to a measuring signal failure, SWAT #3 *)
						OR  IN_AB.bMsg2104;
	ELSE
		bSigFail	   :=	IN_AB.bMsg2101 OR IN_AB.bMsg2102;
		xTON_SigFail(IN:= bSigFail, PT:= T#24h);
		xTON_SigFail_2103(IN:= IN_AB.bMsg2103, PT:= T#30s);
		xTON_SigFail_2104(IN:= IN_AB.bMsg2104, PT:= T#30s);

		xMsg3003.Set   :=  (bSigFail OR IN_AB.bMsg2103 OR IN_AB.bMsg2104) 
				AND(	    xTON_SigFail.Q
					OR		xTON_SigFail_2103.Q
					OR		xTON_SigFail_2104.Q
					OR  NOT IN_AB.tEng_Run.Do 
					OR(    (IN_AB.bMsg2101 OR IN_AB.bMsg2104) AND(IN_AB.bMsg2102 OR IN_AB.bMsg2103))	
					OR		xMsg3003.Set);
	END_IF;
	xMsg3003.PT	       := T#0s;
	xMsg3003.Prio 	   := 3;
	xMsg3003.RiskClass := 4;
	xMsg3003.Reset 	   := TRUE;		(* autoreset *)
	xMsg3003();
	OUT_AB.bMsg3003    := xMsg3003.Q;		
	MM2VIS.bMsg3003    := xMsg3003.Q;
	(********************************************************************************************************************
	Safety-related application software source code (EN 13849-1 / 4.6.3): END
	*********************************************************************************************************************)


	(*---------------------------------------------------------------------------*)
	(* operating messages *)

	(* B1239 general trip *)
	xMsg1239.Enable		:=	IN_AB.tPB2MM.bSys_Run;
	xMsg1239.Set		:=	bGnlTrip;
	xMsg1239.Reset		:=	TRUE;
	xMsg1239();
	MM2VIS.bMsg1239		:= xMsg1239.Q;

	(* B1240 general warning *)
	xTOF_GnlWarning(IN:= bGnlWarning, PT:= T#1s); (* to avoid message with resistent bGnlWarning *)

	xMsg1240.Enable		:=	IN_AB.tPB2MM.bSys_Run;
	xMsg1240.Set		:=	xTOF_GnlWarning.Q;
	xMsg1240.Reset		:=	TRUE;
	xMsg1240();
	MM2VIS.bMsg1240		:= xMsg1240.Q;

	(* B1253 warm restart *)
	xTOF_WarmRestart(IN:= NOT bWarmRestart, PT:= T#3m);
	bWarmRestart := TRUE;

	xMsg1253.Enable		:=	FALSE;	(* no permanent memory available *)
	xMsg1253.Set		:=	xTOF_WarmRestart.Q;
	xMsg1253.Reset		:=	TRUE;
	xMsg1253();
	MM2VIS.bMsg1253		:= xMsg1253.Q;

	(* B1254 cold restart *) 
	xTOF_ColdRestart(IN:= NOT bColdRestart, PT:= T#3m);
	bColdRestart := TRUE;

	xMsg1254.Enable		:=	TRUE;
	xMsg1254.Set		:=	xTOF_ColdRestart.Q;
	xMsg1254.Reset		:=	TRUE;
	xMsg1254();
	MM2VIS.bMsg1254		:= xMsg1254.Q;

	(* B1256 reset *)
	xMsg1256.Enable		:=	TRUE;
	xMsg1256.Set		:=	bResetWarning;
	xMsg1256.Reset		:=	TRUE;
	xMsg1256();
	MM2VIS.bMsg1256		:= xMsg1256.Q;

	(* B3252 remote reset *) 
	xMsg3252.Enable		:=	TRUE;
	xMsg3252.Set		:=	bRemResCmd;
	xMsg3252.Reset		:=	TRUE;
	xMsg3252();
	MM2VIS.bMsg3252		:= xMsg3252.Q;
	
	(* W9389 Remote acknowledgement not possible (too many or safety trip) *)
	xMsg9389.Enable		:= Para.iResetRemRiskClass > 0;
	xMsg9389.Set		:= bRemResWarning;
	xMsg9389.PT	        := T#0s;
	xMsg9389.Prio 	    := 4;
	xMsg9389.RiskClass  := 4;
	xMsg9389();
	MM2VIS.bMsg9389		:= xMsg9389.Q;
	
	(* B template 
	xMsg.Enable		:=	TRUE;
	xMsg.Set		:=	bBool;
	xMsg.Reset		:=	TRUE;
	xMsg();
	MM2VIS.bMsg		:= xMsg.Q;
	*)

	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1_AB	:= tAB2MM.bGnlTrip1   OR tMM2AB.bGnlTrip1;
	bGnlTrip2_AB	:= tAB2MM.bGnlTrip2   OR tMM2AB.bGnlTrip2;
	bGnlTrip3_AB	:= tAB2MM.bGnlTrip3   OR tMM2AB.bGnlTrip3;
	bGnlWarning_AB	:= tAB2MM.bGnlWarning OR tMM2AB.bGnlWarning;

	bGnlTrip_AB		:= bGnlTrip1_AB OR bGnlTrip2_AB OR bGnlTrip3_AB;
	
(*******************************************************************************)
END_PROGRAM
