TYPE
	PROGRAMMER_INFO : 	STRUCT 
		DO_NOT_SORT_PARA : STRING[40] := 'DO NOT CHANGE PARAMETER SORTING!'; (*DO NOT CHANGE PARAMETER SORTING!*) (*ADD NEW PARAMETER ONLY AT THE END OF THE Para STRUCTURE. DO NOT DELETE existing Para items.*)
	END_STRUCT;
	Para_AB_struct : 	STRUCT 
		iEng_Motortype : INT; (*Para motortype*) (*OldName:motortyp; Cycle:5;*)
		bVISA : BOOL; (*PARA [12259]: monitoring according VISA*) (*OldName:VISA; Cycle:5;*)
		rN_EngStart_LimHi : REAL; (*PARA [11296]: speed engine start limit high [1/min]*) (*OldName:GW_DREHZ; Cycle:5;*)
		rN_EngStart_HyHi : REAL; (*PARA [11295]: speed engine start limit high hysteresis [1/min]*) (*OldName:HY_DREHZ; Cycle:5;*)
		bResetRemActive : BOOL; (*PARA [10000]: remote reset active*) (*OldName:sel_rrActive; Cycle:5;*)
		iResetRemRiskClass : INT; (*PARA [10001]: remote reset risk class*) (*OldName:sel_rrClass; Cycle:5;*)
	END_STRUCT;
END_TYPE
