
TYPE
	PROGRAMMER_INFO : 	STRUCT 
		DO_NOT_SORT_PARA : STRING[40] := 'DO NOT CHANGE PARAMETER SORTING!'; (*DO NOT CHANGE PARAMETER SORTING!*) (*ADD NEW PARAMETER ONLY AT THE END OF THE Para STRUCTURE. DO NOT DELETE existing Para items.*)
	END_STRUCT;
	PARA_MO_Struct : 	STRUCT 
		iEng_Motortype : INT; (*PARA: engine motortype*) (*OldName:Motortype; Cycle:;*)
		rU_IgnMon_LimActive : REAL; (*PARA [12155]: ignition voltage start monitoring *) (*OldName:LimitActiv; Cycle:;*)
		rU_IgnMon_LimHy : REAL; (*PARA [12088]: hysteresis for start monitoring *) (*OldName:LimitHyst; Cycle:;*)
		bIgnMon_Active : BOOL; (*PARA [12064]: TRUE= monic is enabled *) (*OldName:monic_vis; Cycle:;*)
		iU_Ign_LimMonTrig : INT; (*PARA [12087]: trigger voltage for volt. measure *) (*OldName:TrigVolt; Cycle:;*)
		bIgn_LimitMonitorActive : ARRAY[0..4]OF BOOL; (*Para: Type of voltage limit monitoring*) (*OldName:MonLimitOn; Cycle:;*)
		tIgn_LimitMonitor : ARRAY[0..4]OF _tMonicLimitREAL; (*Para: Ignition voltage monitoring*) (*OldName:LimitMon; Cycle:;*)
		zz_V4_0_ParaVersionEnd : REAL := 4.01; (*! ADD NEW PARAMETER ONLY BELOW THIS LINE ! This is the end of base version parameter and has to stay unchanged. DO NOT CHANGE SORT ORDER of Para!*) (* OldName: new PV; Cycle: 5; *)
	END_STRUCT;
END_TYPE
