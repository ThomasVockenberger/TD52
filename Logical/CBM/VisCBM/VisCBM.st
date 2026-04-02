(*******************************************************************************
AGGR: VIS

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
History:
-------
V4.06.01 	30-07-2018 	502423184		header added, moved rCA_MFBxx to IN_CBM task


Instructions FOR use:
--------------------
- use in a 100ms cycle time

Outstandings:
------------
-

*******************************************************************************)
PROGRAM _INIT

	PINK;
END_PROGRAM

PROGRAM _CYCLIC

(** 1: colormap for that *)
	FOR i:= 1 TO 24 DO
		IF IN_CB.bTripCyl[i]				THEN	MM2VIS.iIdx_CylColor[i]	:=	RED;
		ELSIF IN_CB.bLimpHomeCylRKS_TC5[i]	THEN	MM2VIS.iIdx_CylColor[i]	:=	BLUE;
		ELSIF IN_CB.bLimpHomeCyl[i]			THEN	MM2VIS.iIdx_CylColor[i]	:=	YELLOW;
		ELSIF IN_CB.bSkipCylAct[i]			THEN	MM2VIS.iIdx_CylColor[i]	:=	GREY;
		ELSIF bATDCyl[i]					THEN	MM2VIS.iIdx_CylColor[i]	:=	VIOLET;
		ELSE 						 	 			MM2VIS.iIdx_CylColor[i]	:=	GREEN;
		END_IF
	END_FOR

(** 2: Statistic and CBM Screen visibility **)
	MM2VIS.bScreen_Stat :=	xEngType.Type9 OR Para.bSStat_Ena;
	MM2VIS.bScreen_CBM	:=	xEngType.Type9 OR Para.bSStat_Ena OR Para.bTCBMem_Ena OR Para.bECBMem_Ena OR Para.bSA_PBC_Active;

	MM2VIS.Stat.bScreen		:=	Para.bSStat_Ena;
	MM2VIS.ErrCnt.bScreen	:=	Para.bSA_PBC_Active;
	MM2VIS.TCB.bScreen		:=	Para.bTCBMem_Ena;
	MM2VIS.ECB.bScreen		:=	Para.bECBMem_Ena;

	MM2VIS.bFrictIMEP_Condition_On	:= OUT_CB.bFrictIMEP_Condition_On;

(** 3: SAFI data to HMI *)
	MM2VIS.rCA_MFB10 :=	rCA_MFB10;
	MM2VIS.rCA_MFB90 :=	rCA_MFB90;

END_PROGRAM
