PROGRAM _INIT

	rGCBctOld := Para.rTi_SynchSwitchDel[1];
	rGCBct    := Para.rTi_SynchSwitchDel[1];
	bGCBctd   := FALSE;
	rGCB_On_TimeMax := 300; (* ms *)(* maximum measurement time 300+500=800ms !? *)

END_PROGRAM

