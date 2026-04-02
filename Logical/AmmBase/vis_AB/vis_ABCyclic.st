(*******************************************************************************
vis			visualization

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2020
 
Customized modifications: -
------------------------
 
History:
-------
V0.00.0	24.04.2012	lettenb.	new
V3.99.0	07.03.2013	lettenb.	cleanup
		07.11.2013				messages setted in MsgAB removed, cleanup 
V4.03.0 16.02.2015				protection test (gridcode III) schutzprüfung added
V4.09.0	19.03.2020	lettenb.	protection test: bMMD_BB_AlarmTestEnable, bMMD_BB_AlarmTestOn for VIS added

Instructions for use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	MM2VIS.bGnlTrip1			:=		bGnlTrip1;
	MM2VIS.bGnlTrip2			:=		bGnlTrip2;
	MM2VIS.bGnlTrip3			:=		bGnlTrip3;
	MM2VIS.bGnlTrip				:=		bGnlTrip;
	MM2VIS.bGnlWarning			:=		bGnlWarning;

	MM2VIS.bTriptype1			:=		bTriptype1;
	MM2VIS.bTriptype2			:=		bTriptype2;
	MM2VIS.bTriptype3			:=		bTriptype3;
	MM2VIS.bTriptypeS			:=	NOT IN_AB.tSafetyLoop_Eng.Di;

	MM2VIS.bGnlTripDurEngOp;
	MM2VIS.bAlarmTestEnable		:=		bAlarmTestEnable;
	MM2VIS.bAlarmTestOn			:=		bAlarmTestOn;
	MM2VIS.iAlarmTestRestTime	:=		iAlarmTestRestTime;

	MM2VIS.bMMD_GenAlarmTestEnable		:=	bMMD_GenAlarmTestEnable;
	MM2VIS.bMMD_GenAlarmTestOn			:=	bMMD_GenAlarmTestOn;
	MM2VIS.iMMD_GenAlarmTestRestTime	:=	iMMD_GenAlarmTestRestTime;
	
	MM2VIS.bMMD_BB_AlarmTestEnable		:=	bMMD_BB_AlarmTestEnable;
	MM2VIS.bMMD_BB_AlarmTestOn			:=	bMMD_BB_AlarmTestOn;
	MM2VIS.iMMD_BB_AlarmTestRestTime	:=	iMMD_BB_AlarmTestRestTime;

END_PROGRAM
