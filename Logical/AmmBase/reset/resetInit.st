(*******************************************************************************
reset			general reset alarms	
				definition remote reset capability for each individual alarm (according TI 1100-0111)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.1	19-06-2009	Brindlinger, new
V3.10.0	12.01.2010	lettenb.	corr.for version 3.10.0
		15.02.2010	lettenb.	DO_W_QUITT, DO_A_QUITT added from task: pb8
		02.03.2010	lettenb.	extended remote reset command with T_FQUITT (was M_FQUITT)
								(needed for reset exhaust temp.alarms generated from task: exhaust)
V3.20.0	24.03.2010	lettenb.	amm numbers br9 (2201-2300) added
		21.05.2010				reset_alarm[1022,1056]: QUITT2_RUHE added
		27.05.2010				AMM test mode added, dianeblau software parts removed
		14.10.2010				NumAmmTest limited, loops reduced to 3999
V3.99.0	06.03.2013	lettenb.	adaption for pilot engine 6	
								AB2MM.bResetRiskClass. added
V4.00.0 04.06.2014	lettenb.	write on VIS2MM.iNumAlarmTest removed(asynchr.running VIS do not change input field value!)
								(in case of illegal alarm nr.: alarm nr will NOT be changed, timer will NOT be started/=diff.to XT3)
		17.06.2014	lettenb.	iNumAlarmTestRun: set to 0 after alarmtest
V4.00.1 04.06.2014	lettenb.	bRemResMem: logic corr., rem.reset counter(5 resets)
V4.00.2 16.02.2015				warm-/cold restart message generation moved to MsgAB
V4.03.0 16.02.2015				protection test (gridcode III) schutzprüfung added
V4.04.0 03.11.2016				IN_AB.bResetRemBus added, prepared for future(wasserer-rosenheim)
		16.11.2016				bResetTrip: xTP_RemResCmd.Q removed, bugfix(reset all risk classes)
V4.05.1 07.03.2018	lettenb.	xR_TRIG_Run: bRun -> IN_AB.tPB2MM.bSys_Run, to avoid 1056 at PLC startup, bugfix
		21.03.2018				protection test mode: passlevel 30->15, request thaler
V4.07.1	24.06.2019	Schmid		valid alarm number space for alarm test/bypass increased from 3999 to 9999 
V4.08.0	24.10.2019	Schmid		test bit for dry test bench added
					   		
Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)
PROGRAM _INIT
	
	(* Reset Dry TB variable *)
	 bDryTB_AB := FALSE;
	 
END_PROGRAM