(*******************************************************************************
Msg_GM	 			 alarms generation MM_GasMixer

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V03.99.00.00	23.01.2013	Tinello		new
				27.05.2013	lettenb.	reset OUT_xx.txx2AB.bGnlTripx changed
V04.01.00.00	13.06.2014	Weitzer		add bit for special gasmixer trip 1083
V04.05.00.00	22.01.2018	Tinello		Release Module added
														
Instructions for use:
--------------------
1) declare alarm with function block "Alm"
	declare buffert alarm bit bMsg<message number>

2) use template to create a new alarm, 
   substitue 0000 by alarm number and make settings:

	xMsg0000.Enable		:=	TRUE;		enable/disable alarm 
	xMsg0000.Set		:=	FALSE;		alarm set condition
	xMsg0000.PT			:=	T#0s;		alarm delay time	
	xMsg0000.Prio		:=	1;			alarm priority: 1-3 = trip, 4 = warning	
	xMsg0000.RiskClass	:=	3;			risk class for remote alarm reset
	xMsg0000.Reset		:=	FALSE;		FALSE: for all standard alarms	prio 1,2,3 and warnings prio 4
										TRUE : for autoreset alarms
													
	bMsg0000			:=	xMsg0000.Q;	connect buffert alarm bit for VIS and control	


3)  expand INIT

3)	include datapoint into OPC configuration for vis

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _CYCLIC	

	(* reset general trip *)
	OUT_GM.tGM2AB.bGnlTrip1		:=	FALSE;
	OUT_GM.tGM2AB.bGnlTrip2		:=	FALSE;
	OUT_GM.tGM2AB.bGnlTrip3		:=	FALSE;
	OUT_GM.tGM2AB.bGnlWarning	:=	FALSE;
	OUT_GM.tGM2AB.bTriptype1	:=	FALSE;
	OUT_GM.tGM2AB.bTriptype2	:=	FALSE;
	OUT_GM.tGM2AB.bTriptype3	:=	FALSE;	


	(*---------------------------------------------------------------------------*)	
	(* A1083 error gasmixer control *)
	xMsg1083.Enable	   	:= bRelModul_ParaSetupOk;	
	xMsg1083.Set       	:= (bErrGM_Ctr OR bErrSGM_Ctr) AND NOT IN_GM.bLeanox_Active AND bOMSS_MAT;
	xMsg1083.PT		   	:= T#0s;
	xMsg1083.Prio	   	:= 2;
	xMsg1083.RiskClass 	:= 3;
	xMsg1083.Reset	   	:= FALSE;
	xMsg1083();
	MM2VIS.bMsg1083		:= xMsg1083.Q;

	
	(* W2086 measuring signal failure gasmixer position *)
	xMsg2086.Enable	   	:= TRUE;					
	xMsg2086.Set       	:= bErrMsGM_Pos;
	xMsg2086.PT		   	:= T#0s;
	xMsg2086.Prio	   	:= 4;
	xMsg2086.RiskClass 	:= 4;
	xMsg2086.Reset	   	:= FALSE;
	xMsg2086();
	MM2VIS.bMsg2086		:= xMsg2086.Q;


	(*---------------------------------------------------------------------------*)
	(* operating messages > AMM *)
	
	(* B template 
	xMsg.Enable		:=	TRUE;
	xMsg.Set		:=	bBool;
	xMsg.Reset		:=	TRUE;
	xMsg();
	MM2VIS.bMsg		:=	xMsg.Q;	*)

	
	(*---------------------------------------------------------------------------*)
	(* general alarms for further module operations *)
	bGnlTrip1 	:= OUT_GM.tGM2AB.bGnlTrip1 		OR IN_GM.tAB2GM.bGnlTrip1;
	bGnlTrip2 	:= OUT_GM.tGM2AB.bGnlTrip2 		OR IN_GM.tAB2GM.bGnlTrip2;
	bGnlTrip3 	:= OUT_GM.tGM2AB.bGnlTrip3 		OR IN_GM.tAB2GM.bGnlTrip3;
	bGnlWarning := OUT_GM.tGM2AB.bGnlWarning 	OR IN_GM.tAB2GM.bGnlWarning;
	bGnlTrip	:= bGnlTrip1 OR bGnlTrip2 OR bGnlTrip3;
	
(*******************************************************************************)
END_PROGRAM
